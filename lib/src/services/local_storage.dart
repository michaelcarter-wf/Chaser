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
  DateTime openPullRequestsUpdated = new DateTime.now();
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

  set openPullRequests(List<GitHubSearchResult> openPullRequests) {
      openPullRequestsUpdated = new DateTime.now();
      List<String> openPrJson = openPullRequests?.map((GitHubSearchResult gsr) {
        return gsr.toMap();
      }).toList();

      // not awaiting these, they shouldn't block
      localStorageStore.save(JSON.encode(openPrJson), LocalStorageConstants.atMentionKey);
      localStorageStore.save(atMentionsUpdated.toIso8601String(), LocalStorageConstants.atMentionUpdatedKey);
  }

  set atMentionPullRequests(List<GitHubSearchResult> atMenionPullRequests) {
    atMentionsUpdated = new DateTime.now();
    List<String> atMentionJson = atMenionPullRequests?.map((GitHubSearchResult ghpr) {
      return ghpr.toMap();
    }).toList();

    // not awaiting these, they shouldn't block
    localStorageStore.save(JSON.encode(atMentionJson), LocalStorageConstants.atMentionKey);
    localStorageStore.save(atMentionsUpdated.toIso8601String(), LocalStorageConstants.atMentionUpdatedKey);
  }

  updateNotificationStatus(GitHubSearchResult gsr) {
    ignoreNotification(gsr);
    watchForNotification(gsr);
  }

  ignoreNotification(GitHubSearchResult gsr) async {
    String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.ignoreNotifications) ?? '[]';
    Set notificationMap = JSON.decode(atMentionJson);
    !gsr.localStorageMeta.notificationsEnabled ? notificationMap.add(gsr.id) : notificationMap.remove(gsr.id);
    localStorageStore.save(notificationMap.toString(), LocalStorageConstants.ignoreNotifications);
  }

  watchForNotification(GitHubSearchResult gsr) async {
    String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.watchNotifications) ?? '[]';
    Set notificationMap = JSON.decode(atMentionJson);
    gsr.localStorageMeta.notificationsEnabled ? notificationMap.add(gsr.id) : notificationMap.remove(gsr.id);
    localStorageStore.save(notificationMap.toString(), LocalStorageConstants.watchNotifications);
  }

  Future<Set> get watchNotifications async {
    String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.watchNotifications) ?? '[]';
    List notificationMap = JSON.decode(atMentionJson);
    return new Set.from(notificationMap);
  }

  Future<Set> get ignoredNotifications async {
    String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.ignoreNotifications) ?? '[]';
    List notificationMap = JSON.decode(atMentionJson);
    return new Set.from(notificationMap);
  }

  /// Gets a list of [GitHubSearchResult] requests from the cache if they exist.
  Future<List<GitHubSearchResult>> get atMentionPullRequests async {
    if (_atMentionPullRequests.isNotEmpty) {
      return _atMentionPullRequests;
    }

    String atMentionJson = await localStorageStore.getByKey(LocalStorageConstants.atMentionKey);

    if (atMentionJson != null && atMentionJson.isNotEmpty) {
      List atMentionObjects = JSON.decode(atMentionJson);

      _atMentionPullRequests = atMentionObjects.map((Map aMPR) {
        return new GitHubSearchResult(aMPR);
      }).toList();
    }

    return _atMentionPullRequests;
  }
}
