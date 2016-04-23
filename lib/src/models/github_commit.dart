part of wChaser.src.models.models;

class GitHubCommentConstants {
  static const body = 'body';
  static const user = 'user';
  static const updatedAt = 'updated_at';
}

class GitHubComment implements GithubBaseModel {
  String body;
  GitHubUser user;
  String updatedAt;

  GitHubComment(json) {
    body = json[GitHubCommentConstants.body];
    user = new GitHubUser(json[GitHubCommentConstants.user]);
    updatedAt = json[GitHubCommentConstants.updatedAt];
  }

  Map toMap() => {
        GitHubCommentConstants.body: body,
        GitHubCommentConstants.updatedAt: updatedAt,
        GitHubCommentConstants.user: user.toMap(),
      };
}
