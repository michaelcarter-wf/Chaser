part of wChaser.src.stores.chaser_stores;

class AtMentionStore extends ChaserStore {
  static final String NAME = 'atMentionStore';

  StreamController alertsController;
  UserStore _userStore;
  LocationStore _locationStore;

  List<GitHubSearchResult> atMentionPullRequests = [];
  List<GitHubSearchResult> displayPullRequests = null;
  DateTime updated = new DateTime.now();
  bool showAll = false;
  bool rowsHideable = true;
  bool loading = true;

  AtMentionStore(ChaserActions chaserActions, GitHubService gitHubService, this._userStore, this._locationStore,
      StatusService statusService, LocalStorageService localStorageService)
      : super(statusService, localStorageService, gitHubService, chaserActions) {

    triggerOnAction(chaserActions.atMentionActions.displayAll, _displayAll);

    chaserActions.locationActions.refreshView.listen((e) {
        if (_locationStore.currentView != ChaserViews.atMentions) {
          return;
        }
      load(force: true);
    });

    chaserActions.atMentionActions.toggleNotification.listen((GitHubSearchResult gsr) {
        if (_locationStore.currentView != ChaserViews.atMentions) {
          return;
        }
        gsr.notificationsActive = !gsr.notificationsActive;
        localStorageService.updateNotificationForPr(gsr);
        trigger();
    });
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
    localStorageService.atMentionPullRequests = atMentionPullRequests;
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

    loading = false;
    trigger();

    displayPullRequests = atMentionPullRequests;
    _displayAll(showAll);

    // TODO move to browser service
    if (chrome.browserAction.available) {
      chrome.browserAction.setBadgeText(new chrome.BrowserActionSetBadgeTextParams(
          text: atMentionPullRequests?.where((GitHubSearchResult pr) => pr.actionNeeded).length.toString()));
    }

    await getPullRequestsStatus(atMentionPullRequests);

    // for (GitHubSearchResult gsr in atMentionPullRequests) {
    //   gitHubService.getPullRequestCommits(gsr.githubPullRequest);
    // }
  }
}
