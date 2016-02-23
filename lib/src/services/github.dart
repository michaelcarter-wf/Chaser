library wChaser.src.services.github;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:intl/intl.dart';
import 'package:fluri/fluri.dart';

import 'package:wChaser/src/services/status_service.dart';
import 'package:wChaser/src/models/models.dart';

final String githubScheme = 'https';
final String githubHost = 'api.github.com';

class GitHubService {
  String _accessToken;
  StatusService _statusService;

  GitHubService({StatusService statusService}) {
    _statusService = statusService;
  }

  Future<List> _requestAuthed(String httpRequestType, String url, {Map sendData}) async {
    Map headers = {'Authorization': 'token $_accessToken'};
    try {
      HttpRequest req = await HttpRequest.request(url, method: httpRequestType, requestHeaders: headers);
      _statusService.authed = true;
      return JSON.decode(req.response.toString());
    } catch (e) {
      _statusService.authed = false;
      print(e);
    }
  }

  Future<GitHubPullRequest> getPullRequest(String url) async {
    List pullRequestJson = await _requestAuthed('GET', url);
    return new GitHubPullRequest(pullRequestJson);
  }

  Future<List<GitHubComment>> getPullRequestComments(GitHubSearchResult pullRequest) async {
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
      ..queryParameters = {'affiliation': 'owner'};

    List<Map> usersReposJson = await _requestAuthed('GET', uri.toString());
    return usersReposJson.map((Map userRepoJson) {
      return new GithubRepo(userRepoJson);
    }).toList();
  }

//  https://api.github.com/search/issues?q=is:open+is:pr+author:bradybecker-wf
  Future<List<GitHubSearchResult>> searchForOpenPullRequests(String login) async {
    Fluri uri = new Fluri()
      ..scheme = githubScheme
      ..host = githubHost
      ..path = 'search/issues';

    var openPrsJson = await _requestAuthed('GET', '${uri.toString()}?q=is:open+is:pr+author:$login');
    return openPrsJson['items'].map((Map openPrJson) {
      return new GitHubSearchResult(openPrJson);
    }).toList();
  }

  //  https://api.github.com/search/issues?q=is:open+is:pr+author:bradybecker-wf
  Future<List<GitHubSearchResult>> searchForAtMentions(String login, {since: null}) async {
    DateTime oneMonthAgo = since ?? new DateTime.now().subtract(new Duration(days: 60));
    String formatted = new DateFormat('yyyy-MM-dd').format(oneMonthAgo);

    Fluri uri = new Fluri()
      ..scheme = githubScheme
      ..host = githubHost
      ..path = 'search/issues';

    var openPrsJson =
        await _requestAuthed('GET', '${uri.toString()}?q=is:open+is:pr+created:>$formatted+mentions:$login');
    return openPrsJson['items'].map((Map openPrJson) {
      return new GitHubSearchResult(openPrJson);
    }).toList();
  }

  Future<GitHubUser> setAndCheckToken(String accessToken) async {
    this._accessToken = accessToken;
    Fluri uri = new Fluri()
      ..scheme = githubScheme
      ..host = githubHost
      ..path = 'user';

    var userJson = await _requestAuthed('GET', uri.toString());
    return new GitHubUser(userJson);
  }

  Future<List<GitHubStatus>> getPullRequestStatus(GitHubPullRequest githubPullReqeust) async {
    var statusJson = await _requestAuthed('GET', githubPullReqeust.statusesUrl);

    return statusJson.map((Map openPrJson) {
      return new GitHubStatus(openPrJson);
    }).toList();
  }
}
