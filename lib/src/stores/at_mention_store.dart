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
      StatusService statusService, localStorageService)
      : super(statusService, localStorageService, gitHubService) {
    _chaserActions.locationActions.refreshView.listen((e) {
      load(force: true);
    });

    triggerOnAction(_chaserActions.atMentionActions.hidePr, _hidePR);
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

  _hidePR(GitHubSearchResult searchResult) {}

  @override
  load({force: false}) async {
    if (_locationStore.currentView != ChaserViews.atMentions) {
      return;
    }
    loading = true;
    trigger();

    List<GitHubSearchResult> cachedAtMentionPullRequests = await localStorageService.atMentionPullRequests;
    print(cachedAtMentionPullRequests.map((test) => test.toMap()));
    Map<String, String> shaCache = new Map.fromIterable(cachedAtMentionPullRequests,
        key: (GitHubSearchResult result) => result.id,
        value: (GitHubSearchResult result) => result.githubPullRequest?.commitSha);
    print(shaCache);

    if (!force && atMentionPullRequests?.isNotEmpty ?? false) {
      updated = localStorageService.atMentionsUpdated;
      atMentionPullRequests = cachedAtMentionPullRequests;
      atMentionPullRequests.forEach((GitHubSearchResult result) {
        result.previousCommit = shaCache[result.id];
      });
    } else {
      await _getChaserAssetsFromGithub();
      atMentionPullRequests.forEach((GitHubSearchResult result) {
        result.previousCommit = shaCache[result.id];
      });
      localStorageService.atMentionPullRequests = atMentionPullRequests;
    }

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
    // print(atMentionPullRequests.map((test) => test.toMap()));
    localStorageService.atMentionPullRequests = atMentionPullRequests;
    _displayAll(showAll);

    // for (GitHubSearchResult gsr in atMentionPullRequests) {
    //   gitHubService.getPullRequestCommits(gsr.githubPullRequest);
    // }
  }
}
