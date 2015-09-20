part of wChaser.src.models.models;

class GitHubComment {
  String body;
  String userLogin;

  GitHubComment(json) {
    body = json['body'];
    userLogin = json['user']['login'];
    print(body);
  }

}