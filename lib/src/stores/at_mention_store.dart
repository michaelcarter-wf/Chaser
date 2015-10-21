library wChaser.src.stores.at_mention_store;

import 'dart:async';

import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/utils/utils.dart';

class AtMentionStore extends Store {

  GitHubService _gitHubService;
  List<GitHubPullRequest> atMentionPullRequests = [];
  // TODO Add updated date

  AtMentionStore() {
    _gitHubService = new GitHubService();
    load();
  }

  load() async {
    List<GitHubNotification> notifications = await _gitHubService.getNotifications();
    List<Future<GitHubPullRequest>> pullRequests = notifications.map((GitHubNotification notification) => _isActionNeeded(notification, _gitHubService)).toList();
    // wait until all come back
    List<GitHubPullRequest> prs = await Future.wait(pullRequests);
    atMentionPullRequests = prs.where((GitHubPullRequest pullRequest) => pullRequest.actionNeeded).toList();
    trigger();
  }

  Future<GitHubPullRequest> _isActionNeeded(GitHubNotification notification, GitHubService gitHubService) async {
    GitHubPullRequest pullRequest = await gitHubService.getPullRequest(notification.pullRequest);
    List<GitHubComment> comments = await gitHubService.getPullRequestComments(pullRequest);
    bool plusOneNeeded = isPlusOneNeeded(comments, 'bradybecker-wf');
    pullRequest.actionNeeded = plusOneNeeded;
    return pullRequest;
  }

}