part of wChaser.src.models.models;

class GitHubNotification {
  String reason;
  String pullRequest;
  bool unread;

  GitHubNotification(json) {
    reason = json['mention'];
    pullRequest = json['subject']['url'];
    unread = json['unread'];
  }

}