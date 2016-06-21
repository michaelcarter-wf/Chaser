part of wChaser.src.stores.chaser_stores;

class AtMentionStore extends ChaserStore {
  static final String NAME = 'atMentionStore';

  StreamController alertsController;
  UserStore _userStore;
  ChaserActions _chaserActions;
  LocationStore _locationStore;

  List<GitHubSearchResult> atMentionPullRequests = [];
  List<GitHubSearchResult> displayPullRequests = null;
  DateTime updated = new DateTime.now();
  bool showAll = false;
  bool rowsHideable = true;
  bool loading = true;

  AtMentionStore(this._chaserActions, GitHubService gitHubService, this._userStore, this._locationStore,
      StatusService statusService, LocalStorageService localStorageService)
      : super(statusService, localStorageService, gitHubService) {
    _chaserActions.locationActions.refreshView.listen((e) {
      load(force: true);
    });

    triggerOnAction(_chaserActions.atMentionActions.displayAll, _displayAll);
  }

  _displayAll(bool displayAll) {
    showAll = displayAll;
    if (showAll == false) {
      displayPullRequests = displayPullRequests.where((GitHubSearchResult pr) => pr.actionNeeded).toList();
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
      List<GitHubComment> comments = await gitHubService.getPullRequestComments(pullRequest);
      pullRequest.actionNeeded = isPlusOneNeeded(comments, _userStore.githubUser.login);
    }
  }

  /// Big Gorilla of a method that gets PRS that need your action from gh via notifications.
  _getChaserAssetsFromGithub() async {
    _clearPullRequests();
    updated = new DateTime.now();
    atMentionPullRequests = await gitHubService.searchForAtMentions(_userStore.githubUser.login);
    localStorageService.addPrsChased(atMentionPullRequests.length);

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
    if (!force && atMentionPullRequests?.isNotEmpty ?? false) {
      updated = localStorageService.atMentionsUpdated;
    } else {
      await _getChaserAssetsFromGithub();
      localStorageService.atMentionPullRequests = atMentionPullRequests;
    }

    // TODO defer this and use the cache
    loading = false;
    trigger();

    displayPullRequests = atMentionPullRequests;
    _displayAll(showAll);

    // TODO move to browser service
    if (chrome.browserAction.available) {
      chrome.browserAction.setBadgeText(new chrome.BrowserActionSetBadgeTextParams(
          text: atMentionPullRequests.where((GitHubSearchResult pr) => pr.actionNeeded).length.toString()));
    }

    await getPullRequestsStatus(atMentionPullRequests);

    for (GitHubSearchResult gsr in atMentionPullRequests) {
      gitHubService.getPullRequestCommits(gsr.githubPullRequest);
    }
  }
}
