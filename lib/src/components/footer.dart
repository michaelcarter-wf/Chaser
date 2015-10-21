library src.components.footer;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart' show Dom;

var Footer = react.registerComponent(() => new _Footer());

final String SHOW_ALL = 'showAll';
class _Footer extends react.Component {

  getInitialState() {
    return {
      SHOW_ALL: true
    };
  }

  showActionNeeded([_]) {

  }

  render() {
    String buttonText = state[SHOW_ALL] ? 'Show Few': 'Show All';

    var leftColumn = (Dom.a()
      ..href = '#'
      ..onClick = showActionNeeded)
    (buttonText);

    var centerColumn = (Dom.em())
      ('updated DATE');

    return (Dom.div()
      ..className = 'footer')
    ([
      (Dom.div()
        ..className = 'small-text text-left col-xs-6'
      )(leftColumn),
      (Dom.div()
        ..className = 'small-text text-right col-xs-6'
      )(centerColumn)
    ]);

  }

}