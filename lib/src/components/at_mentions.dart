library src.components.at_mentions;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
//import 'package:chrome/chrome_app.dart' as Chrome;

import 'package:web_skin_dart/ui_core.dart' show Dom;

import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/components/pull_request_row.dart';


Map<String, dynamic> divStyle = {
  'height': '400px',
  'overflowY':'scroll',
  'width': '100%',
  'backgroundolor': '#FBFBFB'
};

var AtMentions = react.registerComponent(() => new _AtMentions());
class _AtMentions extends react.Component {

  List<GitHubPullRequest> get pullRequests => props['pullRequests'];

  getInitialState() {
    return {
    };
  }

  render() {
    var pullRequestRows = pullRequests.map((GitHubPullRequest gitHubPr) {
      return PullRequestRow({
        'pullRequest': gitHubPr
      });
    });

    return (Dom.div()
      ..style = divStyle)
    (pullRequestRows);
  }

}