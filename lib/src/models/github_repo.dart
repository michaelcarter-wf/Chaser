part of wChaser.src.models.models;

class GithubRepo implements GithubBaseModel {
  String fullName;
  String htmlUrl;
  String pullRequestsUrl;
  String url;

  GithubRepo(Map json) {
    if (json == null) {
      return;
    }

    url = json['url'];
    fullName = json['full_name'];
    htmlUrl = json['html_url'];
    pullRequestsUrl = '$url/pulls';
  }

  Map toMap() => {'full_name': fullName, 'html_url': htmlUrl};
}
