library src.components.pull_request_row;

import 'dart:core';
import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_core.dart' show Dom;

import 'package:wChaser/src/models/models.dart';

var mediaWidth = {'width': '70%'};

var ChaserRow = react.registerComponent(() => new _ChaserRow());

class _ChaserRow extends react.Component {
  GitHubSearchResult get pullRequest => props['pullRequest'];
  bool get hideable => props['get'];

  openNewTab(_) {
    window.open(pullRequest.htmlUrl, pullRequest.id.toString());
  }

  removeThisGuy(_) {}

  renderStatus() {
    if (pullRequest.githubPullRequest?.githubStatus != null) {

      List statuses = [];

      pullRequest.githubPullRequest?.githubStatus.forEach((String key, GitHubStatus ghs) {
        if (ghs.state == 'success') {
          statuses.add(react.div({'className': 'circle passed'}));
        } else if (ghs.state == 'failure') {
          statuses.add(react.div({'className': 'circle failed'}));
        } else {
          statuses.add(react.div({'className': 'circle loading'}));
        }
      });

      return react.div({'className': 'status-container pull-left'}, statuses);
    } else {
      return null;
    }
  }

  renderImage() {
    String actionNeededClass = pullRequest.actionNeeded ? 'action-needed-img' : '';

    return react.span(
        {'className': 'pull-left', 'onClick': openNewTab},
        react.img(
            {'className': 'media-object avatar-image', 'src': pullRequest.githubUser.avatarUrl, 'alt': 'avatar_url'}));
  }

  renderTitle() {
    return (Dom.div()
      ..className = 'media-body pull-left'
      ..style = mediaWidth
      ..onClick = openNewTab)(
        (Dom.small()..className = 'small-text create-date')(
            (Dom.em())(pullRequest.htmlUrl.replaceAll('https://github.com/', ''))),
        (Dom.h6()..className = 'media-heading')(
            pullRequest.title,
            (Dom.br())(),
            (Dom.small()..className = 'small-text')(pullRequest.updatedAtPretty,
                (Dom.span()..className = 'red')(pullRequest.actionNeeded ? ' Action Needed' : ''))));
  }

  render() {
    var removeX = hideable
        ? react.div({'className': 'pull-right chaser-close-button', 'onClick': removeThisGuy},
            react.i({'className': 'close-x icon icon-sm icon-close close-x',}))
        : null;

    return
      react.div({'className':'chaser-row'}, [
        renderImage(),
        react.div({'className': 'media'}, [renderStatus(), renderTitle(), removeX])
      ]);
  }
}
