library src.components.pull_request_status;

import 'dart:html';

import 'package:react/react.dart' as react;

import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/models/models.dart';

var PullRequestStatus = react.registerComponent(() => new _PullRequestStatus());

class _PullRequestStatus extends react.Component {
  GitHubPullRequest get gitHubPullRequest => props['gitHubPullRequest'];
  ChaserActions get actions => props['actions'];
  bool get statusReady => props['statusReady'];

  onMouseOver(react.SyntheticMouseEvent mouseEvent, String context, String description) {
    var content = react.div({}, [
      react.small({'className': 'text-small'}, context),
      react.br({}),
      react.em({}, react.small({'className': 'text-small'}, description)),
    ]);

    actions.popoverActions.showPopover(new PopoverProps(mouseEvent.pageX, mouseEvent.pageY, context, content));
  }

  renderDefault() {
    return react.div({
      'className': 'status-container hide-slide pull-left'
    }, [
      react.div({'className': 'circle passed blink-fast'}),
      react.div({'className': 'circle loading blink'}),
      react.div({'className': 'circle failed blink-slow'})
    ]);
  }

  render() {
    if ((gitHubPullRequest != null || gitHubPullRequest?.githubStatus != null) && statusReady) {
      List statuses = [];

      // find all statuses if they exist
      gitHubPullRequest.githubStatus.forEach((String key, GitHubStatus ghs) {
        if (ghs.state == GitHubStatusState.success) {
          statuses.add(react.div({
            'onMouseOver': (react.SyntheticMouseEvent me) {
              onMouseOver(me, ghs.context, ghs.description);
            },
            'onMouseOut': actions.popoverActions.closePopover,
            'className': 'circle passed',
            'onClick': (e) {
              window.open(ghs.targetUrl, gitHubPullRequest.id.toString());
            }
          }));
        } else if (ghs.state == GitHubStatusState.failure) {
          statuses.add(react.div({
            'onMouseOver': (react.SyntheticMouseEvent me) {
              onMouseOver(me, ghs.context, ghs.description);
            },
            'onMouseOut': actions.popoverActions.closePopover,
            'className': 'circle failed',
            'onClick': (e) {
              window.open(ghs.targetUrl, gitHubPullRequest.id.toString());
            }
          }));
        } else {
          statuses.add(react.div({
            'onMouseOver': (react.SyntheticMouseEvent me) {
              onMouseOver(me, ghs.context, ghs.description);
            },
            'onMouseOut': actions.popoverActions.closePopover,
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
      return renderDefault();
    }
  }
}
