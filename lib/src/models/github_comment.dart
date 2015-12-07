part of wChaser.src.models.models;

class GitHubComment implements GithubBaseModel {
  String body;
  GitHubUser user;

  GitHubComment(json) {
    body = json['body'];
    user = new GitHubUser(json['user']);
  }

  Map toMap() => {'body': body, 'user': user.toMap()};
}
