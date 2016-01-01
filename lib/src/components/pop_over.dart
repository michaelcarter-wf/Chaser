library src.components.popover;

import 'package:react/react.dart' as react;

import 'package:wChaser/src/stores/chaser_store.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/utils/dates.dart';

var PopOver = react.registerComponent(() => new _PopOver());

class _PopOver extends react.Component {
  ChaserActions get chaserActions => props['actions'];
  bool get active => state['active'];

  getInitialState() => {
    'active': false,
    'popOverProps': null
  };

//  componentDidMount(_) {
//    chaserActions.popoverActions.showPopover.listen((PopoverProps props) {
//      print('Open up!');
//
//      setState({
//        'active': true
//      });
//    });
//  }

  render() {
    if (!active) {
      return react.span({});
    }

    return react.div({
      'className': 'chaser-popover',
    }, 'BOOM');
  }
}
