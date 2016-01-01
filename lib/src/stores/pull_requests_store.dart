part of wChaser.src.stores.chaser_stores;

class PullRequestsStore extends Store implements ChaserStore {
  static final String NAME = 'pullRequestsStore';

  UserStore _userStore;
  LocationStore _locationStore;
  ChaserActions _chaserActions;
  GitHubService _gitHubService;
  DateTime updated;
  List<GitHubSearchResult> displayPullRequests;
  bool showAll = null;
  bool rowsHideable = false;
  bool loading = true;

  bool get isHideable => rowsHideable;

  PullRequestsStore(this._chaserActions, this._gitHubService, this._userStore, this._locationStore) {
    updated = new DateTime.now();
    _chaserActions.locationActions.refreshView.listen((e) {
      load(force: true);
    });

    // listen for location changes
    _locationStore.listen((_) {
      load(force: false);
    });

    // listen for successful auth
    triggerOnAction(_chaserActions.authActions.authSuccessful, _authed);
  }

  /// Big Gorilla of a method that gets PRS that need your action from gh via notifications.
  _getChaserAssetsFromGithub() async {
    displayPullRequests = [];
    updated = new DateTime.now();
    displayPullRequests = await _gitHubService.searchForOpenPullRequests(_userStore.githubUser.login);
    trigger();
    _getPullRequestsStatus();
  }

  _getPullRequestsStatus() async {
    for (GitHubSearchResult gsr in displayPullRequests) {
      gsr.githubPullRequest = await _gitHubService.getPullRequest(gsr.pullRequestUrl);
      List<GitHubStatus> githubStatuses = await _gitHubService.getPullRequestStatus(gsr.githubPullRequest);

      // first one in the list should be the current
      githubStatuses.forEach((GitHubStatus ghStatus) {
        gsr.githubPullRequest.githubStatus.putIfAbsent(ghStatus.context, () => ghStatus);
      });
    }
    trigger();
  }

  _authed(bool authSuccessful) {
    if (authSuccessful) {
      load();
    }
  }

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
