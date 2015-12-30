library src.components.footer;

import 'package:react/react.dart' as react;

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
      return react.span({});
    }

    String buttonText = chaserStore.showAll ? 'Show Few' : 'Show All';
    var leftColumn = react.a({
      'href': '#',
      'onClick': showActionNeeded
    }, buttonText);

    return leftColumn;
  }

  render() {
    var rightColumn = react.em({}, getPrettyDates(chaserStore.updated));

    return react.div({'className':'footer'}, [
      react.div({'className': 'small-text text-left col-xs-4'}, renderLeftColumn()),
      react.div({'className': 'small-text text-right col-xs-3'}),
      react.div({'className': 'small-text text-right col-xs-5'}, rightColumn),
      react.div({'className': 'clear'})
    ]);
  }
}
