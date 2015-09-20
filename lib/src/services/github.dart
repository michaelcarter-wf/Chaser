library wChaser.src.services.github;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/constants.dart' as constants;

String gitHubUrl = 'https://api.github.com/';


class GitHubService {
  String accessToken = '29ed73c4694450b7b11c864484806856fd2a3490';

  Future<List> _requestAuthed(String httpRequestType, String url, {Map sendData}) async {
    String jsonData = JSON.encode(sendData); // convert map to String
    Map headers = {
      'Authorization': 'token $accessToken'
    };

    HttpRequest req = await HttpRequest.request(url, method:httpRequestType, requestHeaders:headers);
    return JSON.decode(req.response.toString());
  }

  Future<List<GitHubNotification>> getNotifications() async {
    int oneMonthAgo = new DateTime.now().subtract(new Duration(days:30)).millisecondsSinceEpoch;

    var data = {
        'since': oneMonthAgo,
        'participating': true
    };
    List notifications = await _requestAuthed('GET', '${gitHubUrl}notifications', sendData:data);

    return notifications.map((notification) {
      return new GitHubNotification(notification);
    }).toList();
  }

  Future<PullRequest> getPullRequest(String url) async {
    var pullRequestJson = await _requestAuthed('GET', url);
    return new PullRequest(pullRequestJson);
  }

  Future<List<GitHubComment>> getPullRequestComments(PullRequest pullRequest) async {
    var pullRequestsCommentsJson = await _requestAuthed('GET', pullRequest.commentsUrl);

    return pullRequestsCommentsJson.map((pullRequestJson) {
      return new GitHubComment(pullRequestJson);
    }).toList();
  }

}