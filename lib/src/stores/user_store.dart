part of wChaser.src.stores.chaser_stores;

class UserStore extends Store {
  static final String NAME = 'atMentionStore';
  bool authed = false;
  GitHubUser githubUser;

  bool _ready = false;
  GitHubService _gitHubService;
  ChaserActions _actions;
  LocalStorageStore _localStorageStore;

  bool get isReady => _ready;

  UserStore(this._actions, this._gitHubService) {
    load();
    _actions.authActions.auth.listen(_authUser);
  }

  load() async {
    _localStorageStore = await LocalStorageStore.open();
    String accessToken = await _localStorageStore.getByKey(LocalStorageConstants.githubTokenKey);
    if (accessToken != null) {
      await _authUser(accessToken);
    }
    _ready = true;
    trigger();
  }

  // TODO Store User Object on the location store
  Future _authUser(String ghToken) async {
    try {
      githubUser = await _gitHubService.setAndCheckToken(ghToken);
      authed = true;
      _actions.authActions.authSuccessful(true);
      await _localStorageStore.save(ghToken, LocalStorageConstants.githubTokenKey);
    } catch(e) {
      authed = false;
      _actions.authActions.authSuccessful(false);
    }
    trigger();
  }

}
