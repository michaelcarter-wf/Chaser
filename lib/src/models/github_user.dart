part of wChaser.src.models.models;

class GitHubUser implements GithubBaseModel {
  String login;
  String avatarUrl;
  String userJson;

  GitHubUser(json) {
    if (json == null) {
      return;
    }
    userJson = userJson;
    login = json['login'];
    avatarUrl = json['avatar_url'];
  }

  Map toMap() => {'login': login, 'avatar_url': avatarUrl};
}
