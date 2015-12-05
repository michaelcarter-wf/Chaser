library wChaser.src.services.github;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:fluri/fluri.dart';

import 'package:wChaser/src/models/models.dart';

final String githubScheme = 'https';
final String githubHost = 'api.github.com';

class GitHubService {
//  String accessToken = '29ed73c4694450b7b11c864484806856fd2a3490';
  String accessToken;

  Future<List> _requestAuthed(String httpRequestType, String url, {Map sendData}) async {
    Map headers = {'Authorization': 'token $accessToken'};
    HttpRequest req = await HttpRequest.request(url, method: httpRequestType, requestHeaders: headers);
    return JSON.decode(req.response.toString());
  }

  Future<List<GitHubNotification>> getNotifications({since: null}) async {
    DateTime oneMonthAgo = since ?? new DateTime.now().subtract(new Duration(days: 30));
    Map<String, String> data = {
      'since': oneMonthAgo.toIso8601String(),
      'participating': 'true',
      'reason': 'mention',
      'all': 'true'
    };

    Fluri uri = new Fluri()
      ..scheme = githubScheme
      ..host = githubHost
      ..path = 'notifications'
      ..queryParameters = data;

    List notificationsJson = await _requestAuthed('GET', uri.toString());

    return notificationsJson.map((notificationJson) {
      return new GitHubNotification(notificationJson);
    }).toList();
  }

  Future<GitHubPullRequest> getPullRequest(String url) async {
    var pullRequestJson = await _requestAuthed('GET', url);
    return new GitHubPullRequest(pullRequestJson);
  }

  Future<List<GitHubComment>> getPullRequestComments(GitHubPullRequest pullRequest) async {
    var pullRequestsCommentsJson = await _requestAuthed('GET', pullRequest.commentsUrl);

    return pullRequestsCommentsJson.map((pullRequestJson) {
      return new GitHubComment(pullRequestJson);
    }).toList();
  }

  Future <bool> setAndCheckToken(String accessToken) async {
    this.accessToken = accessToken;
    Fluri uri = new Fluri()
      ..scheme = githubScheme
      ..host = githubHost
      ..path = 'user';

    try {
      await _requestAuthed('GET', uri.toString());
      return true;
    } catch(e) {
      return false;
    }

  }
}
