part of wChaser.src.stores.chaser_stores;

class UserStore extends Store {
  static final String NAME = 'atMentionStore';
  bool authed = false;
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
      authed = await _gitHubService.setAndCheckToken(ghToken);
      await _localStorageStore.save(ghToken, LocalStorageConstants.githubTokenKey);
    } catch(e) {
      print(e);
    }
    trigger();
  }

}
