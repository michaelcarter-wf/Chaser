part of wChaser.src.stores.chaser_stores;

class PullRequestsStore extends Store {
  static final String NAME = 'pullRequestsStore';

  ChaserActions _chaserActions;
  GitHubService _gitHubService;
  DateTime updated = new DateTime.now();
  List<GitHubPullRequest> openPullRequests;

  PullRequestsStore(this._chaserActions, this._gitHubService) {
    load();

    _chaserActions.locationActions.refreshView.listen((e) {
      load(force: true);
    });
  }

  /// Big Gorilla of a method that gets PRS that need your action from gh via notifications.
  _getChaserAssetsFromGithub(LocalStorageStore localStorageStore) async {
    updated = new DateTime.now();

    // TODO Can take the status from the PR and get the smithy goodies
    openPullRequests = await _gitHubService.searchForOpenPullRequests();

//    await localStorageStore.save(JSON.encode(atMentionJson), atMentionLocalStorageKey);
//    await localStorageStore.save(updated.toIso8601String(), atMentionUpdatedLocalStorageKey);
  }

  load({force: false}) async {
    await _getChaserAssetsFromGithub(null);
  }

}
