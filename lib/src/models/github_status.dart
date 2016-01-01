part of wChaser.src.models.models;

class GitHubStatusState {
  static final success = 'success';
  static final failure = 'failure';
}
class GitHubStatusConstants {
  static final updatedAt = 'updated_at';
  static final createdAt = 'created_at';
  static final state = 'state';
  static final targetUrl = 'target_url';
  static final description = 'description';
  static final context = 'context';
}

// https://developer.github.com/v3/repos/statuses/
class GitHubStatus implements GithubBaseModel {
  String updatedAt;
  String createdAt;
  String targetUrl;
  String state;
  String description;
  String context;

  GitHubStatus(json) {
    if (json == null) {
      return;
    }
    updatedAt = json[GitHubStatusConstants.updatedAt];
    createdAt = json[GitHubStatusConstants.createdAt];
    state = json[GitHubStatusConstants.state];
    targetUrl = json[GitHubStatusConstants.targetUrl];
    description = json[GitHubStatusConstants.description];
    context = json[GitHubStatusConstants.context];
  }

  Map toMap() => {
        GitHubStatusConstants.updatedAt: updatedAt,
        GitHubStatusConstants.createdAt: createdAt,
        GitHubStatusConstants.state: state,
        GitHubStatusConstants.targetUrl: targetUrl,
        GitHubStatusConstants.description: description,
        GitHubStatusConstants.context: context
      };
}
