library src.components.pull_request_status;

import 'dart:html';

import 'package:react/react.dart' as react;

import 'package:wChaser/src/stores/chaser_store.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/utils/dates.dart';

var PullRequestStatus = react.registerComponent(() => new _PullRequestStatus());

class _PullRequestStatus extends react.Component {
  GitHubPullRequest get gitHubPullRequest => props['gitHubPullRequest'];
  ChaserActions get actions => props['actions'];

  onMouseOver(react.SyntheticMouseEvent mouseEvent) {
    actions.popoverActions.showPopover(new PopoverProps(mouseEvent.pageX, mouseEvent.pageY, gitHubPullRequest.id));
  }

  render() {
    if (gitHubPullRequest != null || gitHubPullRequest?.githubStatus != null) {
      List statuses = [];

      // find all statuses if they exist
      gitHubPullRequest?.githubStatus.forEach((String key, GitHubStatus ghs) {
        if (ghs.state == GitHubStatusState.success) {
          statuses.add(react.div({
            'onMouseOver': onMouseOver,
            'className': 'circle passed',
            'onClick': (e) {
              window.open(ghs.targetUrl, gitHubPullRequest.id.toString());
            }
          }));
        } else if (ghs.state == GitHubStatusState.failure) {
          statuses.add(react.div({
            'onMouseOver': onMouseOver,
            'className': 'circle failed',
            'onClick': (e) {
              window.open(ghs.targetUrl, gitHubPullRequest.id.toString());
            }
          }));
        } else {
          statuses.add(react.div({
            'onMouseOver': onMouseOver,
            'className': 'circle loading',
            'onClick': (e) {
              window.open(ghs.targetUrl, gitHubPullRequest.id.toString());
            }
          }));
        }
      });

      return react.div({'className': 'status-container show-slide pull-left'}, statuses);
    } else {
      // render default loading
      return react.div({'className': 'status-container hide-slide pull-left'}, [
        react.div({'className': 'circle passed blink-fast'}),
        react.div({'className': 'circle loading blink'}),
        react.div({'className': 'circle failed blink-slow'})
      ]);
    }
  }
}
