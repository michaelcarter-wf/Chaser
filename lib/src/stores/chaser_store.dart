library wChaser.src.stores.chaser_store;

import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/services/status_service.dart';
import 'package:wChaser/src/models/models.dart';

class ChaserStore extends Store {
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

  // to be overridden
  load({force: false}) {}
}
