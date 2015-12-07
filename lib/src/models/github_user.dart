part of wChaser.src.models.models;

class GitHubUser implements GithubBaseModel {
  String login;
  String avatarUrl;

  GitHubUser(json) {
    if (json == null) {
      return;
    }
    login = json['login'];
    avatarUrl = json['avatar_url'];
  }

  Map toMap() => {'login': login, 'avatar_url': avatarUrl};
}
