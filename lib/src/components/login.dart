library src.components.login;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart' show Dom;

import 'package:wChaser/src/actions/actions.dart';

final String ghInput = 'ghInput';

var Login = react.registerComponent(() => new _Login());

class _Login extends react.Component {
  ChaserActions get chaserActions => props['actions'];

  getInitialState() => {'attempts':0};

  submitToken(react.SyntheticEvent e) {
    var inputRef = ref(ghInput);
    InputElement input = react.findDOMNode(inputRef);
    chaserActions.authActions.auth(input.value);

    int attempts = state['attempts'];
    setState({
      'attempts': attempts + 1
    });
  }

  render() {
    return (Dom.div()..style={'padding': '15px'})(
        react.h6({}, 'GitHub Access Token: '),
        react.input({
          'className':'form-control',
          'ref': ghInput,
          'style': state['attempts'] > 0 ? {'border': '1px solid red'}: {}
        }),
        react.br({}),
        (Button()
          ..className ='pull-right'
          ..skin= ButtonSkin.LIGHT
          ..onClick= submitToken)('Submit')
    );
  }
}
