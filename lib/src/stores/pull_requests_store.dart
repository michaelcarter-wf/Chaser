part of wChaser.src.stores.chaser_stores;

class PullRequestsStore extends ChaserStore {
  static final String NAME = 'pullRequestsStore';

  UserStore _userStore;
  LocationStore _locationStore;
  ChaserActions _chaserActions;

  DateTime updated;
  List<GitHubSearchResult> displayPullRequests;
  bool showAll = null;
  bool rowsHideable = false;
  bool loading = true;

  PullRequestsStore(this._chaserActions, GitHubService gitHubService, this._userStore, this._locationStore,
      StatusService statusService, localStorageService)
      : super(statusService, localStorageService, gitHubService) {
    updated = new DateTime.now();
    _chaserActions.locationActions.refreshView.listen((e) {
      load(force: true);
    });

    // listen for location changes
    _locationStore.listen((_) {
      load(force: false);
    });
  }

  _getChaserAssetsFromGithub() async {
    displayPullRequests = [];
    updated = new DateTime.now();
    displayPullRequests = await gitHubService.searchForOpenPullRequests(_userStore.githubUser.login);
    localStorageService.addPrsChased(displayPullRequests.length);
    trigger();
    getPullRequestsStatus(displayPullRequests);
  }

  @override
  load({force: false}) async {
    if (_locationStore.currentView == ChaserViews.pullRequests) {
      loading = true;
      trigger();

      await _getChaserAssetsFromGithub();
      loading = false;
      trigger();
    }
  }
}
