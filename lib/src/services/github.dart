library wChaser.src.services.github;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:fluri/fluri.dart';

import 'package:wChaser/src/models/models.dart';

final String githubScheme = 'https';
final String githubHost = 'api.github.com';

class GitHubService {
  String accessToken = '29ed73c4694450b7b11c864484806856fd2a3490';
//  String accessToken;

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

  Future<List<GitHubPullRequest>> getPullRequests(String url) async {
    var pullRequestsJson = await _requestAuthed('GET', url);
    return [];
  }

  Future<List<GitHubComment>> getPullRequestComments(GitHubPullRequest pullRequest) async {
    var pullRequestsCommentsJson = await _requestAuthed('GET', pullRequest.commentsUrl);

    return pullRequestsCommentsJson.map((pullRequestJson) {
      return new GitHubComment(pullRequestJson);
    }).toList();
  }

  /// Get all repos from github that the authed user owns.
  /// Github docs: https://developer.github.com/v3/repos/#list-your-repositories/
  ///
  /// Returns a list of [GithubRepo].
  Future<List<GithubRepo>> getUsersRepos() async {
    Fluri uri = new Fluri()
      ..scheme = githubScheme
      ..host = githubHost
      ..path = 'user/repos'
      ..queryParameters = {
        'affiliation':'owner'
      };

    List<Map> usersReposJson = await _requestAuthed('GET', uri.toString());
    return usersReposJson.map((Map userRepoJson) {
      return new GithubRepo(userRepoJson);
    }).toList();
  }

//  https://api.github.com/search/issues?q=is:open+is:pr+author:bradybecker-wf&access_token=29ed73c4694450b7b11c864484806856fd2a3490&
  Future<List<GitHubPullRequest>> searchForOpenPullRequests() async {
    Fluri uri = new Fluri()
      ..scheme = githubScheme
      ..host = githubHost
      ..path = 'search/issues';

      var openPrsJson = await _requestAuthed('GET', '${uri.toString()}?q=is:open+is:pr+author:bradybecker-wf');
      return openPrsJson['items'].map((Map openPrJson) {
        return new GitHubPullRequest(openPrJson);
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
