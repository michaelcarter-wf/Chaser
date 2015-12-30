part of wChaser.src.models.models;

class GitHubSearchResultConstants {
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
  static final statusesUrl = 'statuses_url';
  static final pullRequest = 'pull_request';
}

class GitHubSearchResult implements GithubBaseModel {
  bool actionNeeded;
  String commentsUrl;
  String fullName;
  GitHubUser githubUser;
  String pullRequestUrl;
  GitHubPullRequest githubPullRequest;
  String htmlUrl;
  int id;
  bool merged;
  String state;
  String statusesUrl;
  String title;
  String updatedAt;
  String updatedAtPretty;
  String repoFullName;

  bool get isOpen => state == 'open';

  GitHubSearchResult(Map json) {
    if (json == null) {
      return;
    }
    state = json[GitHubSearchResultConstants.state];
    commentsUrl = json[GitHubSearchResultConstants.commentsUrl];
    htmlUrl = json[GitHubSearchResultConstants.htmlUrl];
    statusesUrl = json[GitHubSearchResultConstants.statusesUrl];
    fullName = 'tester';

    // for some reason this can be null
    if (json['head'] != null) {
      fullName = json['head']['repo'][GitHubSearchResultConstants.fullName];
    }

    if (json[GitHubSearchResultConstants.pullRequest] != null) {
      pullRequestUrl = json[GitHubSearchResultConstants.pullRequest]['url'];
    }

    id = json[GitHubSearchResultConstants.id];
    merged = json[GitHubSearchResultConstants.merged];
    title = json[GitHubSearchResultConstants.title];
    updatedAt = json[GitHubSearchResultConstants.updatedAt];
    updatedAtPretty = getPrettyDates(DateTime.parse(updatedAt));
    githubUser = new GitHubUser(json[GitHubSearchResultConstants.githubUser]);

    // make a call to get this later
    githubPullRequest = json['githubPullRequest'] ?? null;

    // this will only come from cached data
    if (json.containsKey(GitHubSearchResultConstants.actionNeeded)) {
      actionNeeded = json[GitHubSearchResultConstants.actionNeeded];
    }
  }

  Map toMap() => {
        GitHubSearchResultConstants.state: state,
        GitHubSearchResultConstants.commentsUrl: commentsUrl,
        GitHubSearchResultConstants.htmlUrl: htmlUrl,
        GitHubSearchResultConstants.id: id,
        GitHubSearchResultConstants.merged: merged,
        GitHubSearchResultConstants.githubUser: githubUser.toMap(),
        'head': {
          'repo': {GitHubSearchResultConstants.fullName: fullName}
        },
        // if there's no pullRequest present at least put the url in the cache
        GitHubSearchResultConstants.pullRequest: githubPullRequest?.toMap() ?? {'url': pullRequestUrl},
        GitHubSearchResultConstants.title: title,
        GitHubSearchResultConstants.updatedAt: updatedAt,
        GitHubSearchResultConstants.actionNeeded: actionNeeded,
        GitHubSearchResultConstants.statusesUrl: statusesUrl
      };
}
