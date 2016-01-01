library src.components.popover;

import 'package:react/react.dart' as react;

import 'package:wChaser/src/actions/actions.dart';

var PopOver = react.registerComponent(() => new _PopOver());

class _PopOver extends react.Component {
  ChaserActions get chaserActions => props['actions'];
  bool get active => state['active'];

  getInitialState() =>
      {'active': false, 'popOverProps': null, 'pageX': null, 'pageY': null, 'id': null, 'content': null};

  componentDidMount(_) {
    chaserActions.popoverActions.closePopover.listen(close);
    chaserActions.popoverActions.showPopover.listen((PopoverProps popOverProps) {
      if (state['id'] == popOverProps.id && active) {
        return;
      }

      setState({
        'active': true,
        'pageX': popOverProps.pageX + 10,
        'pageY': popOverProps.pageY - 5,
        'id': popOverProps.id,
        'content': popOverProps.content
      });
    });
  }

  close(_) {
    setState({'active': false});
  }

  render() {
    var location = {'top': state['pageY'], 'left': state['pageX']};

    if (!active) {
      return react.span({});
    }

    return react.div({'style': location, 'className': 'chaser-popover'}, state['content']);
  }
}
