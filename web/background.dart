import 'dart:async';

import 'package:chrome/chrome_ext.dart' as chrome;
import 'package:lawndart/lawndart.dart' show LocalStorageStore;

import 'package:wChaser/src/constants.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/services/local_storage.dart';
import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/utils/utils.dart';

GitHubService _gitHubService = new GitHubService();
LocationStorageService locationStorageService = new LocationStorageService();

main() async {
  await locationStorageService.load();

  chrome.alarms.onAlarm.listen((chrome.Alarm alarm) {
    checkForPrs();
  });

  // _processCallback(JsObject data) {
  //   String url = data['url'];
  //   if (url.isNotEmpty) {
  //     if (url.contains('api.')) return;
  //     print(url);
  //   }
  // }

  // JsObject _OnBeforeSendHeaders = context['chrome']['webRequest']['onCompleted'];
  // var filter = new JsObject.jsify({
  //   "urls": ["<all_urls>"]
  // });

  // _OnBeforeSendHeaders.callMethod('addListener', [_processCallback, filter]);

//  checkForStatusUpdates();
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
    pullRequest.actionNeeded = await isPlusOneNeeded(comments, githubUser.login);
  }

  locationStorageService.atMentionPullRequests = atMentionPullRequests;

  List<GitHubSearchResult> actionNeeded =
      atMentionPullRequests.where((GitHubSearchResult gpr) => gpr.actionNeeded).toList();

  if (chrome.browserAction.available) {
    chrome.browserAction.setBadgeText(new chrome.BrowserActionSetBadgeTextParams(text: actionNeeded.length.toString()));
  }
}

checkForStatusUpdates() {
  //    chrome.NotificationOptions no = new chrome.NotificationOptions(title:'Testing', message: 'Baller!', iconUrl: './packages/wChaser/images/github.png', type: chrome.TemplateType.BASIC);
//    chrome.notifications.create(no);
}

Future<GitHubUser> _authUser(String ghToken) async {
  try {
    return await _gitHubService.setAndCheckToken(ghToken);
  } catch (e) {
    print('error authing user $e');
    return null;
  }
}
