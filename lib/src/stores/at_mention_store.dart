part of wChaser.src.stores.chaser_stores;

class AtMentionStore extends Store implements ChaserStore {
  static final String NAME = 'atMentionStore';

  UserStore _userStore;
  ChaserActions _chaserActions;
  LocationStore _locationStore;
  GitHubService _gitHubService;
  List<GitHubSearchResult> atMentionPullRequests = [];
  List<GitHubSearchResult> displayPullRequests = null;
  DateTime updated = new DateTime.now();
  bool showAll = false;
  bool rowsHideable = true;

  AtMentionStore(this._chaserActions, this._gitHubService, this._userStore, this._locationStore) {
    _chaserActions.locationActions.refreshView.listen((e) {
      if (_locationStore.currentView == ChaserViews.atMentions) {
        load(force: true);
      }
    });

    triggerOnAction(_chaserActions.atMentionActions.displayAll, _displayAll);
    triggerOnAction(_chaserActions.authActions.authSuccessful, _authed);
  }

  _authed(bool authSuccessful) {
    if (authSuccessful) {
      load();
    }
  }

  _displayAll(bool displayAll) {
    showAll = displayAll;
    if (showAll == false) {
      displayPullRequests = displayPullRequests?.where((GitHubSearchResult pr) => pr.actionNeeded).toList();
    } else {
      displayPullRequests = atMentionPullRequests;
    }

    trigger();
  }

  /// Reset all the lists at load.
  _clearPullRequests() {
    atMentionPullRequests = [];
    displayPullRequests = [];
  }

  /// Big Gorilla of a method that gets PRS that need your action from gh via notifications.
  _getChaserAssetsFromGithub(LocalStorageStore localStorageStore) async {
    _clearPullRequests();
    updated = new DateTime.now();
    atMentionPullRequests = await _gitHubService.searchForAtMentions(_userStore.githubUser.login);

    for (GitHubPullRequest pullRequest in atMentionPullRequests) {
      List<GitHubComment> comments = await _gitHubService.getPullRequestComments(pullRequest);
      pullRequest.actionNeeded = await isPlusOneNeeded(comments, _userStore.githubUser.login);
    }

    atMentionPullRequests.sort((GitHubSearchResult a, GitHubSearchResult b) {
      if (a.actionNeeded && b.actionNeeded) {
        return 0;
      } else {
        return 1;
      }
    });

    _displayAll(showAll);
  }

  load({force: false}) async {
    LocalStorageStore localStorageStore = await LocalStorageStore.open();
    String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.atMentionLocalStorageKey);

    if (!force && atMentionJson != null && atMentionJson.isNotEmpty) {
      // Pull atMentioned JSON out of the cache.
      String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.atMentionLocalStorageKey);
      List atMentionObjects = JSON.decode(atMentionJson);
      atMentionPullRequests = atMentionObjects.map((Map aMPR) {
        return new GitHubSearchResult(aMPR);
      }).toList();

      // Pull updated date out of the cache.
      String updatedIso8601String =
          await localStorageStore.getByKey(LocalStorageConstants.atMentionUpdatedLocalStorageKey);
      if (updatedIso8601String != null) {
        updated = DateTime.parse(updatedIso8601String);
      }
    } else {
      displayPullRequests = null;
      trigger();
      await _getChaserAssetsFromGithub(localStorageStore);
    }

    // don't need to wait for these, they'll updated once they come in.
    _getPullRequestsStatus().then((_) {
      List<String> atMentionJson = atMentionPullRequests?.map((GitHubSearchResult ghpr) {
        return ghpr.toMap();
      }).toList();

      // not awaiting these, they shouldn't block
      localStorageStore.save(JSON.encode(atMentionJson), LocalStorageConstants.atMentionLocalStorageKey);
      localStorageStore.save(updated.toIso8601String(), LocalStorageConstants.atMentionUpdatedLocalStorageKey);
    });

    displayPullRequests = atMentionPullRequests;
    _displayAll(showAll);
  }

  Future _getPullRequestsStatus() async {
    for (GitHubSearchResult gsr in atMentionPullRequests) {
      gsr.githubPullRequest = await _gitHubService.getPullRequest(gsr.pullRequestUrl);
      List<GitHubStatus> githubStatuses = await _gitHubService.getPullRequestStatus(gsr.githubPullRequest);

      // first one in the list should be the current
      githubStatuses.forEach((GitHubStatus ghStatus) {
        gsr.githubPullRequest.githubStatus.putIfAbsent(ghStatus.context, () => ghStatus);
      });
    }
    trigger();
  }

  Future<GitHubPullRequest> getPRFromNotification(GitHubNotification notification, GitHubService gitHubService) async {
    bool plusOneNeeded = false;
    GitHubPullRequest pullRequest = await gitHubService.getPullRequest(notification.pullRequest);
    if (!pullRequest.merged) {
      List<GitHubComment> comments = await gitHubService.getPullRequestComments(pullRequest);
      plusOneNeeded = isPlusOneNeeded(comments, _userStore.githubUser.login);
    }
    pullRequest.actionNeeded = plusOneNeeded;
    return pullRequest;
  }
}
