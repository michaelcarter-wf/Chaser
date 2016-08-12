part of wChaser.src.models.models;

class GitHubPullRequestConstants {
  static const actionNeeded = 'action_needed';
  static const comments = 'comments';
  static const commentsUrl = 'comments_url';
  static const commitsUrl = 'commits_url';
  static const htmlUrl = 'html_url';
  static const id = 'id';
  static const fullName = 'full_name';
  static const githubUser = 'user';
  static const merged = 'merged';
  static const mergeable = 'mergeable';
  static const sha = 'sha';
  static const state = 'state';
  static const statusesUrl = 'statuses_url';
  static const title = 'title';
  static const updatedAt = 'updated_at';
  static const url = 'url';
}

// https://developer.github.com/v3/pulls/#list-commits-on-a-pull-request
class GitHubPullRequest implements GithubBaseModel {
  bool actionNeeded;
  String commentsUrl;
  String commitsUrl;
  String commitSha;
  int comments;
  String fullName;
  GitHubUser githubUser;
  Map<String, GitHubStatus> githubStatus;
  String htmlUrl;
  int id;
  String url;
  bool merged;
  // could be true, false, or null(still loading)
  var mergeable;
  String state;
  String statusesUrl;
  String title;
  String updatedAt;
  String updatedAtPretty;
  String repoFullName;

  bool get isOpen => state == 'open';

  GitHubPullRequest(json) {
    if (json == null) {
      return;
    }
    comments = json[GitHubPullRequestConstants.comments];
    state = json[GitHubPullRequestConstants.state];
    commentsUrl = json[GitHubPullRequestConstants.commentsUrl];
    commitsUrl = json[GitHubPullRequestConstants.commitsUrl];
    htmlUrl = json[GitHubPullRequestConstants.htmlUrl];
    statusesUrl = json[GitHubPullRequestConstants.statusesUrl];
    fullName = 'tester';
    url = json[GitHubPullRequestConstants.url];

    // for some reason this can be null
    if (json['head'] != null) {
      fullName = json['head']['repo'][GitHubPullRequestConstants.fullName];
      commitSha = json['head'][GitHubPullRequestConstants.sha];
    }
    id = json[GitHubPullRequestConstants.id];
    merged = json[GitHubPullRequestConstants.merged];
    mergeable = json[GitHubPullRequestConstants.mergeable] != null ? json[GitHubPullRequestConstants.mergeable] : null;
    title = json[GitHubPullRequestConstants.title];
    updatedAt = json[GitHubPullRequestConstants.updatedAt];
    updatedAtPretty = updatedAt != null ? getPrettyDates(DateTime.parse(updatedAt)) : null;
    githubUser = new GitHubUser(json[GitHubPullRequestConstants.githubUser]);
    githubStatus = {};

    // this will only come from cached data
    if (json.containsKey(GitHubPullRequestConstants.actionNeeded)) {
      actionNeeded = json[GitHubPullRequestConstants.actionNeeded];
    }
  }

  Map toMap() => {
        GitHubPullRequestConstants.state: state,
        GitHubPullRequestConstants.commitsUrl: commitsUrl,
        GitHubPullRequestConstants.commentsUrl: commentsUrl,
        GitHubPullRequestConstants.comments: comments,
        GitHubPullRequestConstants.htmlUrl: htmlUrl,
        GitHubPullRequestConstants.id: id,
        GitHubPullRequestConstants.merged: merged,
        GitHubPullRequestConstants.githubUser: githubUser.toMap(),
        'head': {
          'repo': {GitHubPullRequestConstants.fullName: fullName},
          GitHubPullRequestConstants.sha: commitSha
        },
        GitHubPullRequestConstants.title: title,
        GitHubPullRequestConstants.url: url,
        GitHubPullRequestConstants.updatedAt: updatedAt,
        GitHubPullRequestConstants.actionNeeded: actionNeeded,
        GitHubPullRequestConstants.statusesUrl: statusesUrl
      };
}
