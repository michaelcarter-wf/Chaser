import 'dart:async';
import 'dart:convert';

import 'package:chrome/chrome_ext.dart' as chrome;

import 'package:lawndart/lawndart.dart' show LocalStorageStore;

import 'package:wChaser/src/constants.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/utils/utils.dart';

GitHubService _gitHubService = new GitHubService();

main() {
  chrome.alarms.onAlarm.listen((chrome.Alarm alarm) {
    checkForPrs();
  });

  checkForPrs();
}

checkForPrs() async {
  LocalStorageStore _localStorageStore = await LocalStorageStore.open();
  String accessToken = await _localStorageStore.getByKey(LocalStorageConstants.githubTokenKey);
  DateTime updated = new DateTime.now();

  GitHubUser githubUser = await _authUser(accessToken);
  if (githubUser == null) {
    print('NO gh user found');
    return;
  }

  List<GitHubSearchResult> atMentionPullRequests = await _gitHubService.searchForAtMentions(githubUser.login);

  for (GitHubSearchResult pullRequest in atMentionPullRequests) {
    List<GitHubComment> comments = await _gitHubService.getPullRequestComments(pullRequest);
    pullRequest.actionNeeded = await isPlusOneNeeded(comments, githubUser.login);
  }

  List<GitHubSearchResult> actionNeeded =
      atMentionPullRequests.where((GitHubSearchResult gpr) => gpr.actionNeeded).toList();

  chrome.browserAction.setBadgeText(new chrome.BrowserActionSetBadgeTextParams(text: actionNeeded.length.toString()));

  List<String> atMentionJson = atMentionPullRequests.map((GitHubSearchResult ghpr) {
    return ghpr.toMap();
  }).toList();

  _localStorageStore.save(JSON.encode(atMentionJson), LocalStorageConstants.atMentionLocalStorageKey);
  _localStorageStore.save(updated.toIso8601String(), LocalStorageConstants.atMentionUpdatedLocalStorageKey);

  chrome.alarms.create(new chrome.AlarmCreateInfo(delayInMinutes: 1), 'refresh');
}

Future<GitHubUser> _authUser(String ghToken) async {
  try {
    return await _gitHubService.setAndCheckToken(ghToken);
  } catch (e) {
    return null;
  }
}
