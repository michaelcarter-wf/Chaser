library wChaser.src.stores.at_mention_store;

import 'dart:async';
import 'dart:convert';

import 'package:w_flux/w_flux.dart';
import 'package:lawndart/lawndart.dart' show LocalStorageStore;

import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/utils/utils.dart';
import 'package:wChaser/src/constants.dart';

final String atMentionLocalStorageKey = 'chaserAtMentionStorage';
final String atMentionUpdatedLocalStorageKey = 'atMentionUpdated';

class LocationStore extends Store {
  static final String NAME = 'atMentionStore';
  bool authed = false;
  GitHubService _gitHubService;

  LocationStore(ChaserActions chaserActions, this._gitHubService) {

    chaserActions.authActions.auth.listen(authUser);
  }

  authUser(String ghToken) async {
    authed = await _gitHubService.setAndCheckToken(ghToken);
    trigger();
  }

}
