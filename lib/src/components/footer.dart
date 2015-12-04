library src.components.footer;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart' show Dom;

import 'package:wChaser/src/stores/at_mention_store.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/utils/utils.dart';
import 'package:wChaser/src/utils/dates.dart';

var Footer = react.registerComponent(() => new _Footer());

class _Footer extends react.Component {
  AtMentionActions get atMentionActions => props[AtMentionActions.NAME];
  AtMentionStore get atMentionStore => props[AtMentionStore.NAME];

  showActionNeeded([_]) {
    atMentionActions.displayAll(!atMentionStore.showAll);
  }

  render() {
    String buttonText = atMentionStore.showAll ? 'Show Few' : 'Show All';

    var leftColumn = (Dom.a()
      ..href = '#'
      ..onClick = showActionNeeded)(buttonText);

    var rightColumn = (Dom.em())(getPrettyDates(atMentionStore.updated));

    return (Dom.div()..className = 'footer')([
      (Dom.div()..className = 'small-text text-left col-xs-4')(leftColumn),
      (Dom.div()..className = 'small-text text-right col-xs-3')(),
      (Dom.div()..className = 'small-text text-right col-xs-5')(rightColumn)
    ]);
  }
}
