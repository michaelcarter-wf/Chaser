part of wChaser.src.stores.chaser_stores;

class PullRequestsStore extends Store {
  static final String NAME = 'pullRequestsStore';

  UserStore _userStore;
  ChaserActions _chaserActions;
  GitHubService _gitHubService;
  DateTime updated = new DateTime.now();
  List<GitHubPullRequest> openPullRequests;

  PullRequestsStore(this._chaserActions, this._gitHubService, this._userStore) {
    _chaserActions.locationActions.refreshView.listen((e) {
      load(force: true);
    });
    triggerOnAction(_chaserActions.authActions.authSuccessful, _authed);
  }

  /// Big Gorilla of a method that gets PRS that need your action from gh via notifications.
  _getChaserAssetsFromGithub(LocalStorageStore localStorageStore) async {
    updated = new DateTime.now();

    // TODO Can take the status from the PR and get the smithy goodies
    openPullRequests = await _gitHubService.searchForOpenPullRequests(_userStore.githubUser.login);
  }

  _authed(bool authSuccessful) {
    if(authSuccessful) {
      load();
    }
  }

  load({force: false}) async {
    await _getChaserAssetsFromGithub(null);
    trigger();
  }

}
