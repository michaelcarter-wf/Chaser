part of wChaser.src.models.models;

class GitHubNotification {
  String reason;
  String pullRequest;
  bool unread;

  GitHubNotification(json) {
    reason = json['reason'];
    pullRequest = json['subject']['url'];
    unread = json['unread'];
  }

}