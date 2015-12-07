part of wChaser.src.models.models;

class GitHubNotification implements GithubBaseModel {
  String reason;
  String pullRequest;
  bool unread;

  // JSON String have to match everywhere
  GitHubNotification(json) {
    reason = json['reason'];
    pullRequest = json['subject']['url'];
    unread = json['unread'];
  }

  Map toMap() => {
        'reason': reason,
        'subject': {'url': pullRequest},
        'unRead': unread
      };
}
