part of wChaser.src.models.models;

class GitHubUser {
  String login;
  String avatarUrl;

  GitHubUser(json) {
    if (json == null) {
      return;
    }
    login = json['login'];
    avatarUrl = json['avatar_url'];
  }
}