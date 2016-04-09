library wChaser.src.stores.chaser_store;

import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/services/local_storage.dart';
import 'package:wChaser/src/services/status_service.dart';
import 'package:wChaser/src/models/models.dart';

class ChaserStore extends Store {
  List<GitHubSearchResult> displayPullRequests;
  LocationStorageService localStorageService;
  DateTime updated;
  bool showAll;
  bool rowsHideable;
  bool loading;
  StatusService _statusService;

  ChaserStore(StatusService statusService, this.localStorageService) {
    _statusService = statusService;
    _statusService.auth.listen((_) {
      load();
    });
  }

  // to be overridden
  load({force: false}) {}
}
