import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:chrome/chrome_ext.dart' as chrome;

import 'package:lawndart/lawndart.dart' show LocalStorageStore;

import 'package:wChaser/src/constants.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/services/local_storage.dart';
import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/utils/utils.dart';

GitHubService _gitHubService = new GitHubService();
LocalStorageService localStorageService = new LocalStorageService();

class ChaserAlert {
  String title;
  String message;
  ChaserAlert(this.title, this.message);
}

main() async {
  await localStorageService.load();
  chrome.alarms.onAlarm.listen((chrome.Alarm alarm) {
    checkForPrs();
  });

  checkForPrs();
  chrome.alarms.create(new chrome.AlarmCreateInfo(periodInMinutes: 15), 'refresh');
}

checkForPrs() async {
  LocalStorageStore _localStorageStore = await LocalStorageStore.open();
  String accessToken = await _localStorageStore.getByKey(LocalStorageConstants.githubTokenKey);

  GitHubUser githubUser = await _authUser(accessToken);
  if (githubUser == null) {
    print('NO gh user found');
    return;
  }

  List<GitHubSearchResult> atMentionPullRequests = await _gitHubService.searchForAtMentions(githubUser.login);

  for (GitHubSearchResult pullRequest in atMentionPullRequests) {
    List<GitHubComment> comments = await _gitHubService.getPullRequestComments(pullRequest);
    pullRequest.localStorageMeta.actionNeeded = await isPlusOneNeeded(comments, githubUser.login);
  }

  localStorageService.atMentionPullRequests = atMentionPullRequests;

  List<GitHubSearchResult> actionNeeded =
      atMentionPullRequests.where((GitHubSearchResult gpr) => gpr.localStorageMeta.actionNeeded).toList();

  if (chrome.browserAction.available) {
    chrome.browserAction.setBadgeText(new chrome.BrowserActionSetBadgeTextParams(text: actionNeeded.length.toString()));
  }

  getPullRequestsStatus(atMentionPullRequests);
  List<GitHubSearchResult> userPrs = await _gitHubService.searchForOpenPullRequests(githubUser.login);
  getPullRequestsStatus(userPrs);
}

// chrome service
throwAlert(ChaserAlert chaserAlert) {
  try {
    chrome.NotificationOptions no = new chrome.NotificationOptions(
        title: chaserAlert.title,
        message: chaserAlert.message,
        iconUrl: './packages/wChaser/images/chaser_grade.png',
        type: chrome.TemplateType.BASIC);
    chrome.notifications.create(no, 'test');
  } catch (e) {
    print(e);
  }
}

// TODO Move this into a reusable class
getPullRequestsStatus(List<GitHubSearchResult> searchResults) async {
  for (GitHubSearchResult gsr in searchResults) {
    if (gsr.localStorageMeta.notificationsEnabled) return;
    gsr.localStorageMeta.githubPullRequest = await _gitHubService.getPullRequest(gsr.pullRequestUrl);

    List<GitHubStatus> githubStatuses =
        await _gitHubService.getPullRequestStatus(gsr.localStorageMeta.githubPullRequest);

    // first one in the list should be the current
    githubStatuses.forEach((GitHubStatus ghStatus) {
      gsr.localStorageMeta.githubPullRequest.githubStatus.putIfAbsent(ghStatus.context, () => ghStatus);
    });

    List<ChaserAlert> alerts = [];
    // check for my user for errors not everyone else.
    gsr.localStorageMeta.githubPullRequest.githubStatus.forEach((String key, GitHubStatus ghs) {
      if (ghs.state == GitHubStatusState.failure) {
        alerts.add(new ChaserAlert('Build Failed', ghs.context));
      } else if (!gsr.localStorageMeta.githubPullRequest.mergeable) {
        alerts.add(new ChaserAlert('Merge Conflicts', gsr.title));
      }
    });

    if (alerts.length == 1) {
      throwAlert(alerts.first);
    } else if (alerts.isNotEmpty) {
      throwAlert(new ChaserAlert('Multiple Alerts', alerts.map((ChaserAlert alert) => '${alert.title}').join('\n')));
    }
  }
}

Future<GitHubUser> _authUser(String ghToken) async {
  try {
    return await _gitHubService.setAndCheckToken(ghToken);
  } catch (e) {
    print('error authing user $e');
    return null;
  }
}
