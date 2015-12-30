library wChaser.src.stores.chaser_store;

import 'package:wChaser/src/models/models.dart';

abstract class ChaserStore {
  List<GitHubSearchResult> displayPullRequests;
  DateTime updated;
  bool showAll;
  bool rowsHideable;
  bool loading;

  load({force: false});
}
