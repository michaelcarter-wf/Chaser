part of wChaser.src.models.models;

class LocalStorageMetaConstants {
  static const notificationsEnabled = 'notificationsEnabled';
  static const githubPullRequest = 'githubPullRequest';
  static const actionNeeded = 'actionNeeded';
}

class LocalStorageMeta implements GithubBaseModel {
  bool notificationsEnabled;
  GitHubPullRequest githubPullRequest;
  bool actionNeeded;

  LocalStorageMeta(Map json) {
    if (json == null) {
      return;
    }

    notificationsEnabled = json[LocalStorageMetaConstants.notificationsEnabled] ?? false;
    githubPullRequest = new GitHubPullRequest(json[LocalStorageMetaConstants.githubPullRequest]);
    actionNeeded = json[LocalStorageMetaConstants.actionNeeded] ?? false;
  }

  Map toMap() => {
        LocalStorageMetaConstants.notificationsEnabled: notificationsEnabled,
        LocalStorageMetaConstants.githubPullRequest: githubPullRequest.toMap(),
        LocalStorageMetaConstants.actionNeeded: actionNeeded,
      };
}
