part of wChaser.src.stores.chaser_stores;

final String atMentionLocalStorageKey = 'chaserAtMentionStorage';
final String atMentionUpdatedLocalStorageKey = 'atMentionUpdated';

class AtMentionStore extends Store implements ChaserStore {
  static final String NAME = 'atMentionStore';

  UserStore _userStore;
  ChaserActions _chaserActions;
  GitHubService _gitHubService;
  List<GitHubPullRequest> atMentionPullRequests = [];
  List<GitHubPullRequest> displayPullRequests = null;
  DateTime updated = new DateTime.now();
  bool showAll = true;
  bool rowsHideable = true;

  AtMentionStore(this._chaserActions, this._gitHubService, this._userStore) {
    _chaserActions.locationActions.refreshView.listen((e) {
      load(force: true);
    });

    triggerOnAction(_chaserActions.atMentionActions.displayAll, _displayAll);
    triggerOnAction(_chaserActions.authActions.authSuccessful, _authed);
  }

  _authed(bool authSuccessful) {
    if(authSuccessful) {
      load();
    }
  }

  _displayAll(bool displayAll) {
    showAll = displayAll;
    if (showAll == false) {
      displayPullRequests =
          displayPullRequests.where((GitHubPullRequest pr) => pr.actionNeeded).toList();
    } else {
      displayPullRequests = atMentionPullRequests;
    }

    trigger();
  }

  /// Reset all the lists at load.
  _clearPullRequests() {
    atMentionPullRequests = [];
    displayPullRequests = null;
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

    atMentionPullRequests.sort((GitHubPullRequest a, GitHubPullRequest b) {
      if (a.actionNeeded && b.actionNeeded) {
        return 0;
      } else {
        return 1;
      }
    });

    _displayAll(showAll);
    List<String> atMentionJson = atMentionPullRequests.map((GitHubPullRequest ghpr) {
      return ghpr.toMap();
    }).toList();

    // not awaiting these, they shouldn't block
    localStorageStore.save(JSON.encode(atMentionJson), atMentionLocalStorageKey);
    localStorageStore.save(updated.toIso8601String(), atMentionUpdatedLocalStorageKey);
  }

  load({force: false}) async {
    LocalStorageStore localStorageStore = await LocalStorageStore.open();
    String atMentionJson = await localStorageStore.getByKey(atMentionLocalStorageKey);

    if (!force && atMentionJson != null && atMentionJson.isNotEmpty) {
      // Pull atMentioned JSON out of the cache.
      String atMentionJson = await localStorageStore.getByKey(atMentionLocalStorageKey);
      List atMentionObjects = JSON.decode(atMentionJson);
      atMentionPullRequests = atMentionObjects.map((Map aMPR) {
        return new GitHubPullRequest(aMPR);
      }).toList();

      // Pull updated date out of the cache.
      String updatedIso8601String = await localStorageStore.getByKey(atMentionUpdatedLocalStorageKey);
      if (updatedIso8601String != null) {
        updated = DateTime.parse(updatedIso8601String);
      }
    } else {
      displayPullRequests = null;
      trigger();
      await _getChaserAssetsFromGithub(localStorageStore);
    }

    displayPullRequests = atMentionPullRequests;
    trigger();
  }

  Future<GitHubPullRequest> getPRFromNotification(GitHubNotification notification, GitHubService gitHubService) async {
    bool plusOneNeeded = false;
    GitHubPullRequest pullRequest = await gitHubService.getPullRequest(notification.pullRequest);
    if (!pullRequest.merged) {
      List<GitHubComment> comments = await gitHubService.getPullRequestComments(pullRequest);
      plusOneNeeded = isPlusOneNeeded(comments, 'bradybecker-wf');
    }
    pullRequest.actionNeeded = plusOneNeeded;
    return pullRequest;
  }
}
