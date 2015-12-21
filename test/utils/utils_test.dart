import 'package:test/test.dart';

import '../mock_data/comment_response.dart';

import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/utils/utils.dart';

void main() {
  group('Comments: Action Needed', () {
    test('should say action is needed', () {
      List<GitHubComment> comments = commentResponse.map((comment) {
        return new GitHubComment(comment);
      }).toList();

      bool plusOneNeeded = isPlusOneNeeded(comments, 'bradybecker-wf');
      expect(plusOneNeeded, true);
    });

    test('should say is NOT needed', () {
      List<GitHubComment> comments = commentResponse.map((comment) {
        return new GitHubComment(comment);
      }).toList();

      bool plusOneNeeded = isPlusOneNeeded(comments, 'mikekeil-wf');
      expect(plusOneNeeded, false);
    });
  });
}
