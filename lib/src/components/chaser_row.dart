library src.components.chaser_row;

import 'dart:html';

import 'package:react/react.dart' as react;

import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/components/pull_request_status.dart';
import 'package:wChaser/src/components/label.dart';

var mediaWidth = {'width': '100%'};
// var mediaWidth = {};

var ChaserRow = react.registerComponent(() => new _ChaserRow());

class _ChaserRow extends react.Component {
  GitHubSearchResult get pullRequest => props['pullRequest'];
  bool get hideable => props['hideable'];
  ChaserActions get actions => props['actions'];

  getDefaultProps() => {'hideable': true};

  openNewTab(_) {
    window.open(pullRequest.htmlUrl, pullRequest.id.toString());
  }

  removeThisGuy(_) {
    actions.atMentionActions.hidePr(pullRequest);
  }

  renderImage() {
    return react.span(
        {'className': 'flex-item-1', 'onClick': openNewTab},
        react.img(
            {'className': 'media-object avatar-image', 'src': pullRequest.githubUser.avatarUrl, 'alt': 'avatar_url'}));
  }

  // MOVE TO COMPONENT
  renderTitle() {
    List labels = [];
    if (pullRequest.actionNeeded) {
      labels.add(Label({'text': 'Action Needed'}));
    }

    if (pullRequest.githubPullRequest?.mergeable == false) {
      labels.add(Label({'text': 'Merge Conflicts'}));
    }

    if (pullRequest.githubPullRequest != null &&
        pullRequest.previousCommit != null &&
        pullRequest.githubPullRequest.commitSha != null &&
        pullRequest.githubPullRequest.commitSha != pullRequest.previousCommit) {
      labels.add(Label({'text': 'Updated', 'labelType': 'label-info'}));
    }

    // TODO ADD THIS BACK
    if (labels.isEmpty) {
      labels.add(react.small({'className': 'small-text'}, pullRequest.updatedAtPretty));
    }

    return react.div({
      'className': 'media-body',
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
    var hide = hideable
        ? react.div({'className': 'pull-right chaser-close-button', 'onClick': removeThisGuy,},
            react.i({'className': 'glyphicon glyphicon-remove icon icon-sm'}))
        : null;

    return react.div({
      'className': 'chaser-row flex-container'
    }, [
      renderImage(),
      PullRequestStatus({
        'gitHubPullRequest': pullRequest.githubPullRequest,
        'actions': actions,
        'statusReady': props['statusReady']
      }),
      react.div({'className': 'media flex-item-4'}, renderTitle()),
      hide
    ]);
  }
}
