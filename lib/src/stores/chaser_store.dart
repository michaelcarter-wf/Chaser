library wChaser.src.stores.chaser_store;

import 'package:wChaser/src/models/models.dart';

abstract class ChaserStore {
  List<GitHubPullRequest> displayPullRequests;
  DateTime updated;
  bool showAll;
  bool rowsHideable;

  load({force: false});
}
