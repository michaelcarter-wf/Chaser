part of wChaser.src.models.models;

class GitHubComment {
  String body;
  String userLogin;
  GitHubUser gitHubUser;

  GitHubComment(json) {
    body = json['body'];
    gitHubUser = new GitHubUser(json['user']);
  }

}