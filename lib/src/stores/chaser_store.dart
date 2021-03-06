library wChaser.src.stores.chaser_store;

import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/services/local_storage.dart';
import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/services/status_service.dart';
import 'package:wChaser/src/models/models.dart';

class ChaserStore extends Store {
  List<GitHubSearchResult> displayPullRequests;
  LocationStorageService localStorageService;
  DateTime updated;
  GitHubService gitHubService;
  bool showAll;
  bool rowsHideable;
  bool loading;
  StatusService _statusService;

  ChaserStore(StatusService statusService, this.localStorageService, this.gitHubService) {
    _statusService = statusService;
    _statusService.auth.listen((_) {
      load();
    });
  }

  getPullRequestsStatus(List<GitHubSearchResult> searchResults) async {
    for (GitHubSearchResult gsr in searchResults) {
      gsr.githubPullRequest = await gitHubService.getPullRequest(gsr.pullRequestUrl);
      List<GitHubStatus> githubStatuses = await gitHubService.getPullRequestStatus(gsr.githubPullRequest);

      // first one in the list should be the current
      githubStatuses.forEach((GitHubStatus ghStatus) {
        gsr.githubPullRequest.githubStatus.putIfAbsent(ghStatus.context, () => ghStatus);
      });
    }
    trigger();
  }

  // to be overridden
  load({force: false}) {}
}
