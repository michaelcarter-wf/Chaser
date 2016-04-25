library wChaser.src.services.local_storage;

import 'dart:async';
import 'dart:convert';

import 'package:lawndart/lawndart.dart' show LocalStorageStore;

import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/constants.dart';

class LocalStorageService {
  LocalStorageStore localStorageStore;
  List<GitHubSearchResult> _atMentionPullRequests = [];
  DateTime atMentionsUpdated = new DateTime.now();
  int _totalPrsChased;

  load() async {
    localStorageStore = await LocalStorageStore.open();
  }

  Future<int> get totalPrsChased async {
    if (_totalPrsChased != null) {
      return _totalPrsChased;
    }

    String cachedTotalPrsChased = await localStorageStore.getByKey(LocalStorageConstants.totalPrsChased);
    _totalPrsChased = cachedTotalPrsChased != null ? int.parse(cachedTotalPrsChased) : 0;

    return _totalPrsChased;
  }

  addPrsChased(int prsToAdd) async {
    int prsCount = await this.totalPrsChased;
    _totalPrsChased = prsCount += prsToAdd;
    // not awaiting these, they shouldn't block
    localStorageStore.save(_totalPrsChased.toString(), LocalStorageConstants.totalPrsChased);
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

  /// Gets a list of [GitHubSearchResult] requests from the cache if they exist.
  Future<List<GitHubSearchResult>> get atMentionPullRequests async {
    if (_atMentionPullRequests.isNotEmpty) {
      return _atMentionPullRequests;
    }

    String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.atMentionLocalStorageKey);

    if (atMentionJson != null && atMentionJson.isNotEmpty) {
      List atMentionObjects = JSON.decode(atMentionJson);

      _atMentionPullRequests = atMentionObjects.map((Map aMPR) {
        return new GitHubSearchResult(aMPR);
      }).toList();
    }

    return _atMentionPullRequests;
  }
}
