part of wChaser.src.stores.chaser_stores;

class AtMentionStore extends ChaserStore {
  StreamController alertsController;
  UserStore _userStore;

  List<GitHubSearchResult> atMentionPullRequests = [];
  List<GitHubSearchResult> displayPullRequests = null;
  DateTime updated = new DateTime.now();
  bool showAll = false;
  bool rowsHideable = true;
  bool loading = true;

  AtMentionStore(ChaserActions chaserActions, GitHubService gitHubService, this._userStore, LocationStore locationStore,
      StatusService statusService, LocalStorageService localStorageService)
      : super(statusService, localStorageService, gitHubService, chaserActions, locationStore) {
    viewName = ChaserViews.atMentions.toString();
    triggerOnAction(chaserActions.atMentionActions.displayAll, _displayAll);
  }

  _displayAll(bool displayAll) {
    showAll = displayAll;
    if (showAll == false) {
      displayPullRequests =
          displayPullRequests?.where((GitHubSearchResult pr) => pr.localStorageMeta.actionNeeded).toList();
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
      pullRequest.localStorageMeta.actionNeeded = isPlusOneNeeded(comments, _userStore.githubUser.login);
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
      return b.localStorageMeta.actionNeeded.toString().compareTo(a.localStorageMeta.actionNeeded.toString());
    });
  }

  @override
  load({force: false}) async {
    print('LOAINDG');
    loading = true;
    bool setCache = false;
    trigger();

    atMentionPullRequests = await localStorageService.atMentionPullRequests;
    print(atMentionPullRequests);
    if (!force && atMentionPullRequests?.isNotEmpty) {
      updated = localStorageService.atMentionsUpdated;
    } else {
      await _getChaserAssetsFromGithub();
      setCache = true;
    }

    loading = false;
    trigger();

    displayPullRequests = atMentionPullRequests;
    _displayAll(showAll);

    // TODO move to browser service
    // if (chrome.browserAction.available) {
    //   chrome.browserAction.setBadgeText(new chrome.BrowserActionSetBadgeTextParams(
    //       text: atMentionPullRequests?.where((GitHubSearchResult pr) => pr.localStorageMeta.actionNeeded).length.toString()));
    // }

    await getPullRequestsStatus(atMentionPullRequests);
    if (setCache == true) {
      print(atMentionPullRequests.first.toMap().toString());
      localStorageService.atMentionPullRequests = atMentionPullRequests;
    }

    // for (GitHubSearchResult gsr in atMentionPullRequests) {
    //   gitHubService.getPullRequestCommits(gsr.githubPullRequest);
    // }
  }
}
