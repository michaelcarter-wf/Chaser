library wChaser.src.stores.at_mention_store;

import 'dart:async';

import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/utils/utils.dart';
import 'package:wChaser/src/constants.dart';

class AtMentionStore extends Store {

  GitHubService _gitHubService;
  List<GitHubPullRequest> atMentionPullRequests = [];
  List<GitHubPullRequest> allMentionPullRequests = [];
  // TODO Add updated date

  AtMentionStore() {
    _gitHubService = new GitHubService();
    load();
  }

  /// reset all the lists at load
  _clearPullRequests() {
    atMentionPullRequests = [];
    allMentionPullRequests = [];
  }

  load() async {
    _clearPullRequests();
    List<GitHubNotification> notifications = await _gitHubService.getNotifications();
    List<GitHubNotification> actionableNotifications = notifications.where((GitHubNotification notification) => notification.reason == MENTION).toList();

    List<Future<GitHubPullRequest>> pullRequests = actionableNotifications.map((GitHubNotification notification) => _isActionNeeded(notification, _gitHubService)).toList();
    // wait until all come back
    List<GitHubPullRequest> prs = await Future.wait(pullRequests);
    atMentionPullRequests = prs.where((GitHubPullRequest pullRequest) => pullRequest.isOpen()).toList();
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