library src.components.chaser_grid;

import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/chaser_row.dart';
import 'package:wChaser/src/components/loading.dart';
import 'package:wChaser/src/components/pop_over.dart';
import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/stores/chaser_store.dart';

Map<String, dynamic> divStyle = {'height': '400px', 'overflowY': 'auto', 'width': '100%', 'backgroundolor': '#FBFBFB'};

var ChaserGrid = react.registerComponent(() => new _ChaserGrid());

class _ChaserGrid extends react.Component {
  ChaserStore get chaserStore => props['chaserStore'];
  ChaserActions get chaserActions => props['actions'];

  render() {
    var content = Loading({});

    if (!chaserStore.loading && chaserStore.displayPullRequests.length > 0) {
      content = chaserStore.displayPullRequests.map((GitHubSearchResult gitHubSearchResult) {
        return ChaserRow(
            {'pullRequest': gitHubSearchResult, 'hideable': chaserStore.rowsHideable, 'actions': chaserActions});
      }).toList();
    } else if (!chaserStore.loading) {
      content = react.div({
        'className': 'chaser-grid-empty'
      }, [
        'I got nothing for ya',
        react.br({}),
        react.a({'href': '#', 'className': 'refresh', 'onClick': (_) => chaserActions.locationActions.refreshView()},
            'refresh')
      ]);
    }

    return react.div({
      'style': divStyle
    }, [
      PopOver({'actions': chaserActions}),
      content
    ]);
  }
}
