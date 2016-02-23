library wChaser.src.stores.chaser_store;

import 'package:wChaser/src/services/status_service.dart';
import 'package:wChaser/src/models/models.dart';

abstract class ChaserStore {
  List<GitHubSearchResult> displayPullRequests;
  DateTime updated;
  bool showAll;
  bool rowsHideable;
  bool loading;
  StatusService _statusService;

  ChaserStore(StatusService statusService) {
    _statusService = statusService;
    _statusService.authStream.stream.listen((_) {
      load();
    });
  }

  load({force: false});
}
