library src.components.footer;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_core.dart' show Dom;

import 'package:wChaser/src/stores/chaser_store.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/utils/dates.dart';

var Footer = react.registerComponent(() => new _Footer());

class _Footer extends react.Component {
  ChaserActions get chaserActions => props['actions'];
  ChaserStore get chaserStore => props['chaserStore'];

  showActionNeeded([_]) {
    chaserActions.atMentionActions.displayAll(!chaserStore.showAll);
  }

  renderLeftColumn() {
    if (chaserStore.showAll == null) {
      return react.span({}, 'nadda');
    }

    String buttonText = chaserStore.showAll ? 'Show Few' : 'Show All';

    var leftColumn = (Dom.a()
      ..href = '#'
      ..onClick = showActionNeeded)(buttonText);

    return leftColumn;
  }

  render() {
    print('Updated ${getPrettyDates(chaserStore.updated)}');
    var rightColumn = (Dom.em())(getPrettyDates(chaserStore.updated));

    return (Dom.div()..className = 'footer')([
      (Dom.div()..className = 'small-text text-left col-xs-4')(renderLeftColumn()),
      (Dom.div()..className = 'small-text text-right col-xs-3')(),
      (Dom.div()..className = 'small-text text-right col-xs-5')(rightColumn)
    ]);
  }
}
