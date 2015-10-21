part of wChaser.src.models.models;

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

  GitHubPullRequest(json) {
    if (json == null) {
      return;
    }
    state = json['state'];
    commentsUrl = json['comments_url'];
    htmlUrl = json['html_url'];
    fullName = 'tester';

    // for some reason this can be null
    if (json['head'] != null) {
      fullName = json['head']['repo']['full_name'];
    }
    id = json['id'];
    title = json['title'];
    updatedAt = json['updated_at'];
    githubUser = new GitHubUser(json['user']);
  }

  bool isOpen() {
    return state == 'open';
  }

  setActionNeeded(bool actionNeeded) {
    this.actionNeeded = actionNeeded;
  }

}