library wChaser.src.stores.chaser_stores;

import 'dart:async';
import 'dart:convert';

import 'package:w_flux/w_flux.dart';
import 'package:lawndart/lawndart.dart' show LocalStorageStore;

import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/utils/utils.dart';
import 'package:wChaser/src/constants.dart';

part './user_store.dart';
part './at_mention_store.dart';
part './pull_requests_store.dart';
part './location_store.dart';

class ChaserStores {
  static final name = 'chaserStores';
  UserStore userStore;
  AtMentionStore atMentionStore;
  LocationStore locationStore;
  PullRequestsStore pullRequestsStore;

  ChaserStores(ChaserActions chaserActions, GitHubService gitHubService) {
    userStore = new UserStore(chaserActions, gitHubService);
    atMentionStore = new AtMentionStore(chaserActions, gitHubService, userStore);
    pullRequestsStore = new PullRequestsStore(chaserActions, gitHubService, userStore);
    locationStore = new LocationStore(chaserActions);
  }
}