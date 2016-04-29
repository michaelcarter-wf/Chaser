part of wChaser.src.stores.chaser_stores;

class PullRequestsStore extends ChaserStore {
  static final String NAME = 'pullRequestsStore';

  UserStore _userStore;
  LocationStore _locationStore;

  DateTime updated;
  List<GitHubSearchResult> displayPullRequests;
  bool showAll = null;
  bool rowsHideable = false;
  bool loading = true;

  PullRequestsStore(ChaserActions chaserActions, GitHubService gitHubService, this._userStore, this._locationStore,
      StatusService statusService, LocalStorageService localStorageService)
      : super(statusService, localStorageService, gitHubService, chaserActions) {
    updated = new DateTime.now();

    // listen for location changes
    _locationStore.listen((_) {
      load(force: false);
    });

    chaserActions.locationActions.refreshView.listen((e) {
      if (_locationStore.currentView != ChaserViews.pullRequests) {
        return;
      }
      load(force: true);
    });

    chaserActions.atMentionActions.toggleNotification.listen((GitHubSearchResult gsr) {
      if (_locationStore.currentView != ChaserViews.pullRequests) {
        return;
      }
      gsr.notificationsActive = !gsr.notificationsActive;
      localStorageService.updateNotificationStatus(gsr);
      trigger();
    });
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
      gsr.notificationsActive = ignored ? false : true;
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
    if (_locationStore.currentView == ChaserViews.pullRequests) {
      loading = true;
      trigger();

      await _getChaserAssetsFromGithub();
      loading = false;
      trigger();
    }
  }
}
