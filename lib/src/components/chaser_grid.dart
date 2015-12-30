library src.components.at_mentions;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';

import 'package:web_skin_dart/ui_core.dart' show Dom;

import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/components/loading.dart';
import 'package:wChaser/src/components/chaser_row.dart';
import 'package:wChaser/src/stores/chaser_store.dart';

Map<String, dynamic> divStyle = {'height': '400px', 'overflowY': 'auto', 'width': '100%', 'backgroundolor': '#FBFBFB'};

var ChaserGrid = react.registerComponent(() => new _ChaserGrid());

class _ChaserGrid extends react.Component {
  ChaserStore get chaserStore => props['chaserStore'];

  render() {
    var content = Loading({});

    if (chaserStore.displayPullRequests != null) {
      content = chaserStore.displayPullRequests.map((GitHubSearchResult gitHubSearchResult) {
        return ChaserRow({'pullRequest': gitHubSearchResult, 'hideable': chaserStore.rowsHideable});
      });
    }

    return (Dom.div()..style = divStyle)(content);
  }
}
