library src.components.at_mentions;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';

import 'package:web_skin_dart/ui_core.dart' show Dom;

import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/components/loading.dart';
import 'package:wChaser/src/components/at_mention_row.dart';

Map<String, dynamic> divStyle = {
  'height': '400px',
  'overflowY': 'scroll',
  'width': '100%',
  'backgroundolor': '#FBFBFB'
};

var ChaserGrid = react.registerComponent(() => new _ChaserGrid());

class _ChaserGrid extends react.Component {
  List<GitHubPullRequest> get pullRequests => props['pullRequests'];
  AtMentionActions get atMentionActions => props[AtMentionActions.NAME];

  render() {
    var content = Loading({});

    if (pullRequests != null) {
      content = pullRequests.map((GitHubPullRequest gitHubPr) {
        return ChaserRow({'pullRequest': gitHubPr});
      });
    }

    return (Dom.div()..style = divStyle)(content);
  }
}
