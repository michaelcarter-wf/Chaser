part of wChaser.src.models.models;

class GithubPullRequestStatus implements GithubBaseModel {
  String fullName;
  String htmlUrl;
  String pullRequestsUrl;

  GithubPullRequestStatus(Map json) {
    if (json == null) {
      return;
    }

    fullName = json['full_name'];
    htmlUrl = json['html_url'];
    pullRequestsUrl = '$htmlUrl/pulls';
  }

  Map toMap() => {'full_name': fullName, 'html_url': htmlUrl};
}
