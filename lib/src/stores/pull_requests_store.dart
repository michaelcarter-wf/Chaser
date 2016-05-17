part of wChaser.src.stores.chaser_stores;

class PullRequestsStore extends ChaserStore {
  static final String NAME = 'pullRequestsStore';

  UserStore _userStore;

  DateTime updated;
  List<GitHubSearchResult> displayPullRequests;
  bool showAll = null;
  bool rowsHideable = false;
  bool loading = true;

  PullRequestsStore(ChaserActions chaserActions, GitHubService gitHubService, this._userStore,
      LocationStore locationStore, StatusService statusService, LocalStorageService localStorageService)
      : super(statusService, localStorageService, gitHubService, chaserActions, locationStore) {
    viewName = ChaserViews.pullRequests.toString();
    updated = new DateTime.now();
  }

  _getChaserAssetsFromGithub() async {
    displayPullRequests = [];
    updated = new DateTime.now();
    displayPullRequests = await gitHubService.searchForOpenPullRequests(_userStore.githubUser.login);
    Set notificationPrs = await localStorageService.watchNotifications;
    Set ignoredPrs = await localStorageService.ignoredNotifications;

    displayPullRequests.forEach((GitHubSearchResult gsr) {
      bool watched = notificationPrs.contains(gsr.id);
      bool ignored = ignoredPrs.contains(gsr.id);
      gsr.localStorageMeta.notificationsEnabled = ignored ? false : true;
      if (!watched && !ignored) {
        localStorageService.updateNotificationStatus(gsr);
      }
    });
    localStorageService.addPrsChased(displayPullRequests.length);
    trigger();
    getPullRequestsStatus(displayPullRequests);
  }

  @override
  load({force: false}) async {
    loading = true;
    trigger();

    await _getChaserAssetsFromGithub();
    loading = false;
    trigger();
  }
}
