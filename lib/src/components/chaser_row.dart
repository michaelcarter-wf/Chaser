library src.components.chaser_row;

import 'dart:html';

import 'package:react/react.dart' as react;

import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/components/pull_request_status.dart';
import 'package:wChaser/src/components/label.dart';

var mediaWidth = {'width': '100%'};

var ChaserRow = react.registerComponent(() => new _ChaserRow());

class _ChaserRow extends react.Component {
  GitHubSearchResult get pullRequest => props['pullRequest'];
  bool get hideable => props['hideable'];
  ChaserActions get actions => props['actions'];

  openNewTab(_) {
    window.open(pullRequest.htmlUrl, pullRequest.id.toString());
  }

  removeThisGuy(_) {}

  renderImage() {
    return react.span(
        {'className': 'flex-item', 'onClick': openNewTab},
        react.img(
            {'className': 'media-object avatar-image', 'src': pullRequest.githubUser.avatarUrl, 'alt': 'avatar_url'}));
  }

  renderTitle() {
    List labels = [];
    if (pullRequest.actionNeeded) {
      labels.add(Label({'text': 'Action Needed'}));
    }

    if (pullRequest.githubPullRequest?.mergeable == false) {
      labels.add(Label({'text': 'Merge Conflicts'}));
    }

    if (labels.isEmpty) {
      labels.add(react.small({'className': 'small-text'}, pullRequest.updatedAtPretty));
    }

    return react.div({
      'className': 'media-body pull-left',
      'style': mediaWidth,
      'onClick': openNewTab
    }, [
      react.small({'className': 'small-text create-date'},
          react.em({}, pullRequest.htmlUrl.replaceAll('https://github.com/', ''))),
      react.h6({'className': 'media-heading'}, pullRequest.title),
      labels
    ]);
  }

// fa fa-comments-o
  render() {
    var removeX = hideable
        ? react.div({'className': 'pull-right chaser-close-button', 'onClick': removeThisGuy},
            react.i({'className': 'close-x icon icon-sm icon-close close-x',}))
        : null;

    var comments = pullRequest.comments > 0
        ? react.div({
            'className': 'pull-right comment-icon'
          }, [
            '${pullRequest.comments.toString()} ',
            react.i({'className': 'glyphicon glyphicon-comment icon icon-sm'})
          ])
        : null;

    return react.div({
      'className': 'chaser-row flex-container'
    }, [
      renderImage(),
      PullRequestStatus({'gitHubPullRequest': pullRequest.githubPullRequest, 'actions': actions}),
      react.div({'className': 'media'}, renderTitle())
    ]);
  }
}
