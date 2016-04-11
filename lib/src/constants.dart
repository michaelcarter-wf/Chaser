library wChaser.src.constants;

class LocalStorageConstants {
  static const String githubTokenKey = 'github';
  static const String atMentionLocalStorageKey = 'chaserAtMentionStorage';
  static const String atMentionUpdatedLocalStorageKey = 'atMentionUpdated';
  static const String totalPrsChased = 'totalPrsChased';
}

enum ChaserViews { atMentions, pullRequests }

final String localStorageKey = 'github';
final String mention = 'mention';

final int leftArrowKey = 37;
final int rightArrowKey = 39;
