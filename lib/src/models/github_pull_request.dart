part of wChaser.src.models.models;

class GitHubPullRequestConstants {
  static final actionNeeded = 'action_needed';
  static final state = 'state';
  static final commentsUrl = 'comments_url';
  static final htmlUrl = 'html_url';
  static final fullName = 'full_name';
  static final id = 'id';
  static final title = 'title';
  static final updatedAt = 'updated_at';
  static final githubUser = 'user';
  static final merged = 'merged';
}

class GitHubPullRequest {
  String state;
  String commentsUrl;
  String htmlUrl;
  int id;
  GitHubUser githubUser;
  String fullName;
  String title;
  String updatedAt;
  bool actionNeeded;
  bool merged;

  bool get isOpen => state == 'open';

  GitHubPullRequest(Map json) {
    if (json == null) {
      return;
    }
    state = json[GitHubPullRequestConstants.state];
    commentsUrl = json[GitHubPullRequestConstants.commentsUrl];
    htmlUrl = json[GitHubPullRequestConstants.htmlUrl];
    fullName = 'tester';

    // for some reason this can be null
    if (json['head'] != null) {
      fullName = json['head']['repo'][GitHubPullRequestConstants.fullName];
    }
    id = json[GitHubPullRequestConstants.id];
    merged = json[GitHubPullRequestConstants.merged];
    title = json[GitHubPullRequestConstants.title];
    updatedAt = json[GitHubPullRequestConstants.updatedAt];
    githubUser = new GitHubUser(json[GitHubPullRequestConstants.githubUser]);

    // this will only come from cached data
    if (json.containsKey(GitHubPullRequestConstants.actionNeeded)) {
      actionNeeded = json[GitHubPullRequestConstants.actionNeeded];
    }
  }

  Map toMap() => {
        GitHubPullRequestConstants.state: state,
        GitHubPullRequestConstants.commentsUrl: commentsUrl,
        GitHubPullRequestConstants.htmlUrl: htmlUrl,
        GitHubPullRequestConstants.id: id,
        GitHubPullRequestConstants.merged: merged,
        GitHubPullRequestConstants.githubUser: githubUser.toMap(),
        'head': {
          'repo': {GitHubPullRequestConstants.fullName: fullName}
        },
        GitHubPullRequestConstants.title: title,
        GitHubPullRequestConstants.updatedAt: updatedAt,
        GitHubPullRequestConstants.actionNeeded: actionNeeded,
      };
}
