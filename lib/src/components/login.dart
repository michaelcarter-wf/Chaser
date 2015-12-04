library src.components.login;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart' show Dom;

final String ghInput = 'ghInput';

var Login = react.registerComponent(() => new _Login());

class _Login extends react.Component {

  submitToken(react.SyntheticEvent e) {
    var inputRef = ref(ghInput); //return react jsObject
    InputElement input = react.findDOMNode(inputRef);
    props['onLogin'](input.value);
  }

  render() {
    return (Dom.div()..style={'padding': '15px'})(
        react.h6({}, 'GitHub Access Token: '),
        react.input({
          'className':'form-control',
          'ref': ghInput
        }),
        react.br({}),
        (Button()
          ..className ='pull-right'
          ..skin= ButtonSkin.LIGHT
          ..onClick= submitToken)('Submit')
    );
  }
}
