library wChaser.src.services.local_storage;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:crypto/crypto.dart';
import 'package:lawndart/lawndart.dart' show LocalStorageStore;

import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/constants.dart';

class LocationStorageService {
  LocalStorageStore localStorageStore;
  List<GitHubSearchResult> _atMentionPullRequests = [];
  DateTime atMentionsUpdated = new DateTime.now();

  load() async {
    localStorageStore = await LocalStorageStore.open();
  }

  /// Gets a list of [GitHubSearchResult] requests from the cache if they exist.
  Future<List<GitHubSearchResult>> get atMentionPullRequests async {
    if (_atMentionPullRequests.isNotEmpty) {
      return _atMentionPullRequests;
    }

    LocalStorageStore localStorageStore = await LocalStorageStore.open();
    String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.atMentionLocalStorageKey);

    if (atMentionJson.isNotEmpty) {
      List atMentionObjects = JSON.decode(atMentionJson);

      _atMentionPullRequests = atMentionObjects.map((Map aMPR) {
        return new GitHubSearchResult(aMPR);
      }).toList();
    }

    return _atMentionPullRequests;
  }

  set atMentionPullRequests(List<GitHubSearchResult> atMenionPullRequests) {
    atMentionsUpdated = new DateTime.now();
    List<String> atMentionJson = atMenionPullRequests?.map((GitHubSearchResult ghpr) {
      return ghpr.toMap();
    }).toList();

    // not awaiting these, they shouldn't block
    localStorageStore.save(JSON.encode(atMentionJson), LocalStorageConstants.atMentionLocalStorageKey);
    localStorageStore.save(atMentionsUpdated.toIso8601String(), LocalStorageConstants.atMentionUpdatedLocalStorageKey);
  }
}
