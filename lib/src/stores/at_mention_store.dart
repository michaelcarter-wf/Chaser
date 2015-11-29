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

class AtMentionStore extends Store {
  static final String NAME = 'atMentionStore';

  GitHubService _gitHubService;
  List<GitHubPullRequest> atMentionPullRequests = [];
  List<GitHubPullRequest> displayAtMentionPullRequests= [];
  DateTime updated = new DateTime.now();
  bool showAll = true;

  // TODO Add updated date

  AtMentionStore(AtMentionActions atMentionActions) {
    _gitHubService = new GitHubService();
    load();

    atMentionActions.refresh.listen(load);
    triggerOnAction(atMentionActions.displayAll, _displayAll);
  }

  _displayAll(bool displayAll) {
    showAll = displayAll;
    if (showAll == false) {
      displayAtMentionPullRequests = displayAtMentionPullRequests.where((GitHubPullRequest pr) => pr.actionNeeded).toList();
    } else {
      displayAtMentionPullRequests = atMentionPullRequests;
    }

    print(displayAtMentionPullRequests);
    trigger();
  }

  /// reset all the lists at load
  _clearPullRequests() {
    atMentionPullRequests = [];
    displayAtMentionPullRequests = [];
  }

  /// Big Gorilla of a method that gets PRS that need your action from gh via notifications.
  _getChaserAssetsFromGithub(LocalStorageStore localStorageStore) async {
    _clearPullRequests();
    updated = new DateTime.now();

    // get all notifications that user is participating in
    List<GitHubNotification> notifications = await _gitHubService.getNotifications();
    List<GitHubNotification> actionableNotifications =
        notifications.where((GitHubNotification notification) => notification.reason == MENTION).toList();

    // get the PRs From the notifications
    List<Future<GitHubPullRequest>> pullRequests = actionableNotifications
        .map((GitHubNotification notification) => getPRFromNotification(notification, _gitHubService))
        .toList();

    // wait until PR all come back
    List<GitHubPullRequest> prs = await Future.wait(pullRequests);

    atMentionPullRequests = prs.where((GitHubPullRequest pullRequest) => (pullRequest.isOpen)).toList();
    _displayAll(showAll);

    List<String> atMentionJson = atMentionPullRequests.map((GitHubPullRequest ghpr) {
      return ghpr.toMap();
    }).toList();

    await localStorageStore.save(JSON.encode(atMentionJson), atMentionLocalStorageKey);
  }

  load([_]) async {
    LocalStorageStore localStorageStore = await LocalStorageStore.open();
    String atMentionJson = await localStorageStore.getByKey(atMentionLocalStorageKey);

    if (atMentionJson != null && atMentionJson.isNotEmpty) {
      String atMentionJson = await localStorageStore.getByKey(atMentionLocalStorageKey);
      List atMentionObjects = JSON.decode(atMentionJson);
      atMentionPullRequests = atMentionObjects.map((Map aMPR) {
        return new GitHubPullRequest(aMPR);
      }).toList();
    } else {
      await _getChaserAssetsFromGithub(localStorageStore);
    }

    displayAtMentionPullRequests = atMentionPullRequests;

    trigger();
  }

  Future<GitHubPullRequest> getPRFromNotification(GitHubNotification notification, GitHubService gitHubService) async {
    bool plusOneNeeded = false;
    GitHubPullRequest pullRequest = await gitHubService.getPullRequest(notification.pullRequest);
    if (!pullRequest.merged) {
      List<GitHubComment> comments = await gitHubService.getPullRequestComments(pullRequest);
      plusOneNeeded = isPlusOneNeeded(comments, 'bradybecker-wf');
    }
    pullRequest.actionNeeded = plusOneNeeded;
    return pullRequest;
  }
}
