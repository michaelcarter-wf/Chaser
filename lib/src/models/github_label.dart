part of wChaser.src.models.models;

class GitHubLabelConstants {
  static const name = 'name';
  static const color = 'color';
}

class GitHubLabel implements GithubBaseModel {
  String name;
  String color;

  GitHubLabel(json) {
    name = json[GitHubLabelConstants.name];
    color = json[GitHubLabelConstants.color];
  }

  Map toMap() => {GitHubLabelConstants.name: name, GitHubLabelConstants.color: color,};
}
