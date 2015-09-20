library wChaser.src.utils.utils;

import 'package:wChaser/src/models/models.dart';

// checks all comments for the current user's +1
bool isPlusOneNeeded(List<GitHubComment> gitHubComments, String userId) {
  bool plusOneNeeded = true;
  GitHubComment atMentionedComment;

  gitHubComments.forEach((GitHubComment gitHubComment) {
    if (gitHubComment.body.contains('@$userId')) {
      atMentionedComment = gitHubComment;
      plusOneNeeded = true;
    } else if (plusOneNeeded && gitHubComment.userLogin == userId) {
      plusOneNeeded = !gitHubComment.body.contains('+1');
    }
  });

  return plusOneNeeded;
}