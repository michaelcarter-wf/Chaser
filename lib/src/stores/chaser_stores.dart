library wChaser.src.stores.chaser_stores;

import 'dart:async';
import 'dart:convert';

import 'package:chrome/chrome_ext.dart' as chrome;
import 'package:lawndart/lawndart.dart' show LocalStorageStore;
import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/constants.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/services/local_storage.dart';
import 'package:wChaser/src/services/status_service.dart';
import 'package:wChaser/src/stores/chaser_store.dart';
import 'package:wChaser/src/utils/utils.dart';

part './user_store.dart';
part './at_mention_store.dart';
part './pull_requests_store.dart';
part './location_store.dart';

class ChaserStores {
  static final name = 'chaserStores';
  UserStore userStore;
  AtMentionStore atMentionStore;
  LocationStore locationStore;
  LocationStorageService localStorageService;
  PullRequestsStore pullRequestsStore;
  DateTime updated;
  StatusService statusService;

  ChaserStores(ChaserActions chaserActions, this.localStorageService) {
    statusService = new StatusService();
    GitHubService gitHubService = new GitHubService(statusService: statusService);
    userStore = new UserStore(chaserActions, gitHubService);
    locationStore = new LocationStore(chaserActions);
    atMentionStore =
        new AtMentionStore(chaserActions, gitHubService, userStore, locationStore, statusService, localStorageService);
    pullRequestsStore = new PullRequestsStore(
        chaserActions, gitHubService, userStore, locationStore, statusService, localStorageService);
  }
}
