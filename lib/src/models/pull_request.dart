part of wChaser.src.models.models;

class PullRequest {
  String state;
  String commentsUrl;
  String htmlUrl;
  int id;

  PullRequest(json) {
    state = json['state'];
    commentsUrl = json['comments_url'];
    htmlUrl = json['html_url'];
    id = json['id'];
  }

}