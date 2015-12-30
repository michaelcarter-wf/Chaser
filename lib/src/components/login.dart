library src.components.login;

import 'dart:html';

import 'package:react/react.dart' as react;

import 'package:wChaser/src/actions/actions.dart';

final String ghInput = 'ghInput';

var Login = react.registerComponent(() => new _Login());

class _Login extends react.Component {
  ChaserActions get chaserActions => props['actions'];

  getInitialState() => {'attempts': 0};

  submitToken(react.SyntheticEvent e) {
    var inputRef = ref(ghInput);
    InputElement input = react.findDOMNode(inputRef);
    chaserActions.authActions.auth(input.value);

    int attempts = state['attempts'];
    setState({'attempts': attempts + 1});
  }

  render() {
    return react.div({
      'style': {'padding': '15px'}
    }, [
      react.h6({}, 'GitHub Access Token: '),
      react.input({
        'className': 'form-control',
        'ref': ghInput,
        'style': state['attempts'] > 0 ? {'border': '1px solid red'} : {}
      }),
      react.br({}),
      react.button({'onClick': submitToken, 'className': 'btn btn-default pull-right', 'type': 'submit'}, 'Submit')
    ]);
  }
}
