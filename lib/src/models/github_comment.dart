part of wChaser.src.models.models;

class GitHubCommitConstants {
  static const body = 'body';
  static const user = 'user';
  static const updatedAt = 'updated_at';
}

class GitHubCommit implements GithubBaseModel {
  String body;
  GitHubUser user;
  String updatedAt;

  GitHubCommit(json) {
    body = json[GitHubCommitConstants.body];
    user = new GitHubUser(json[GitHubCommitConstants.user]);
    updatedAt = json[GitHubCommitConstants.updatedAt];
  }

  Map toMap() => {
        GitHubCommitConstants.body: body,
        GitHubCommitConstants.updatedAt: updatedAt,
        GitHubCommitConstants.user: user.toMap(),
      };
}
