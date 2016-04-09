part of wChaser.src.stores.chaser_stores;

class AtMentionStore extends ChaserStore {
  static final String NAME = 'atMentionStore';

  StreamController alertsController;
  UserStore _userStore;
  ChaserActions _chaserActions;
  LocationStore _locationStore;
  GitHubService _gitHubService;

  List<GitHubSearchResult> atMentionPullRequests = [];
  List<GitHubSearchResult> displayPullRequests = null;
  DateTime updated = new DateTime.now();
  bool showAll = false;
  bool rowsHideable = true;
  bool loading = true;

  AtMentionStore(this._chaserActions, this._gitHubService, this._userStore, this._locationStore,
      StatusService statusService, LocalStorageService localStorageService)
      : super(statusService, localStorageService) {
    _chaserActions.locationActions.refreshView.listen((e) {
      load(force: true);
    });

    triggerOnAction(_chaserActions.atMentionActions.displayAll, _displayAll);
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

  _getPullRequestComments() async {
    for (GitHubSearchResult pullRequest in atMentionPullRequests) {
      List<GitHubComment> comments = await _gitHubService.getPullRequestComments(pullRequest);
      pullRequest.numberOfComments = comments.length;
      pullRequest.actionNeeded = await isPlusOneNeeded(comments, _userStore.githubUser.login);
    }
  }

  /// Big Gorilla of a method that gets PRS that need your action from gh via notifications.
  _getChaserAssetsFromGithub() async {
    _clearPullRequests();
    updated = new DateTime.now();
    atMentionPullRequests = await _gitHubService.searchForAtMentions(_userStore.githubUser.login);
    await _getPullRequestComments();

    atMentionPullRequests.sort((GitHubSearchResult a, GitHubSearchResult b) {
      return b.actionNeeded.toString().compareTo(a.actionNeeded.toString());
    });
  }

  @override
  load({force: false}) async {
    if (_locationStore.currentView != ChaserViews.atMentions) {
      return;
    }
    loading = true;
    trigger();

    atMentionPullRequests = await localStorageService.atMentionPullRequests;
    if (!force && atMentionPullRequests?.isNotEmpty) {
      updated = localStorageService.atMentionsUpdated;
    } else {
      await _getChaserAssetsFromGithub();
    }

    // don't need to wait for these, they'll updated once they come in.
    _getPullRequestsStatus();

    // TODO defer this and use the cache
    loading = false;
    trigger();

    displayPullRequests = atMentionPullRequests;
    _displayAll(showAll);

    // TODO move to browser service
    if (chrome.browserAction.available) {
      chrome.browserAction.setBadgeText(new chrome.BrowserActionSetBadgeTextParams(
          text: atMentionPullRequests?.where((GitHubSearchResult pr) => pr.actionNeeded).length.toString()));
    }
  }

  Future _getPullRequestsStatus() async {
    for (GitHubSearchResult gsr in atMentionPullRequests) {
      if (gsr.pullRequestUrl == null) {
        print('url is null ${gsr.fullName}');
        continue;
      }
      gsr.githubPullRequest = await _gitHubService.getPullRequest(gsr.pullRequestUrl);
      List<GitHubStatus> githubStatuses = await _gitHubService.getPullRequestStatus(gsr.githubPullRequest);

      // first one in the list should be the current
      githubStatuses.forEach((GitHubStatus ghStatus) {
        gsr.githubPullRequest.githubStatus.putIfAbsent(ghStatus.context, () => ghStatus);
      });
    }

    localStorageService.atMentionPullRequests = atMentionPullRequests;
    trigger();
  }
}
