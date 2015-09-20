// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/header.dart';
import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/utils/utils.dart';

void main() async {
  reactClient.setClientConfiguration();

  var component = react.div({"className": "somehing"}, Header({}));

  react.render(component, querySelector('#output'));

  GitHubService gitHubService = new GitHubService();
  List<GitHubNotification> notifications = await gitHubService.getNotifications();
  PullRequest pullRequest = await gitHubService.getPullRequest(notifications[1].pullRequest);
  List<GitHubComment> comments = await gitHubService.getPullRequestComments(pullRequest);
  bool plusOneNeeded = isPlusOneNeeded(comments, 'bradybecker-wf');
  print(plusOneNeeded);
//  querySelector('#output').text = 'Your Dart app is running.';

}
