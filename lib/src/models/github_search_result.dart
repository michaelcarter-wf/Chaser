part of wChaser.src.models.models;

class GitHubSearchResultConstants {
  static const actionNeeded = 'action_needed';
  static const state = 'state';
  static const commentsUrl = 'comments_url';
  static const comments = 'comments';
  static const htmlUrl = 'html_url';
  static const fullName = 'full_name';
  static const id = 'id';
  static const labels = 'labels';
  static const title = 'title';
  static const updatedAt = 'updated_at';
  static const githubUser = 'user';
  static const merged = 'merged';
  static const statusesUrl = 'statuses_url';
  static const pullRequest = 'pull_request';
  static const notificationsActive = 'notifications_active';
  static const localStorageMeta = 'localStorageMeta';
}

class GitHubSearchResult implements GithubBaseModel {
  String commentsUrl;
  int comments;
  String fullName;
  GitHubUser githubUser;
  String pullRequestUrl;
  List<GitHubLabel> githubLabels;
  String htmlUrl;
  int id;
  bool merged;
  String state;
  String statusesUrl;
  String title;
  String updatedAt;
  String repoFullName;

  bool get isOpen => state == 'open';

  LocalStorageMeta localStorageMeta;

  // not returned from endpoint
  String updatedAtPretty;

  GitHubSearchResult(Map json) {
    if (json == null) {
      return;
    }
    comments = json[GitHubSearchResultConstants.labels] != null ? json[GitHubSearchResultConstants.comments] : 0;
    state = json[GitHubSearchResultConstants.state];
    commentsUrl = json[GitHubSearchResultConstants.commentsUrl];
    htmlUrl = json[GitHubSearchResultConstants.htmlUrl];
    statusesUrl = json[GitHubSearchResultConstants.statusesUrl];

    githubLabels = json[GitHubSearchResultConstants.labels] != null
        ? json[GitHubSearchResultConstants.labels].map((labelJson) {
            return new GitHubLabel(labelJson);
          }).toList()
        : [];

    // for some reason this can be null
    fullName = json['head'] != null ? json['head']['repo'][GitHubSearchResultConstants.fullName] : null;

    if (json[GitHubSearchResultConstants.pullRequest] != null) {
      pullRequestUrl = json[GitHubSearchResultConstants.pullRequest]['url'];
    }

    id = json[GitHubSearchResultConstants.id];
    merged = json[GitHubSearchResultConstants.merged];
    title = json[GitHubSearchResultConstants.title];
    updatedAt = json[GitHubSearchResultConstants.updatedAt];
    updatedAtPretty = getPrettyDates(DateTime.parse(updatedAt));
    githubUser = new GitHubUser(json[GitHubSearchResultConstants.githubUser]);

    localStorageMeta = new LocalStorageMeta(json[GitHubSearchResultConstants.localStorageMeta]);
  }

  Map toMap() => {
        GitHubSearchResultConstants.comments: comments,
        GitHubSearchResultConstants.state: state,
        GitHubSearchResultConstants.commentsUrl: commentsUrl,
        GitHubSearchResultConstants.htmlUrl: htmlUrl,
        GitHubSearchResultConstants.id: id,
        GitHubSearchResultConstants.merged: merged,
        GitHubSearchResultConstants.githubUser: githubUser.toMap(),
        'head': {
          'repo': {GitHubSearchResultConstants.fullName: fullName}
        },
        GitHubSearchResultConstants.title: title,
        GitHubSearchResultConstants.updatedAt: updatedAt,
        GitHubSearchResultConstants.localStorageMeta: localStorageMeta.toMap()
      };
}
