import 'package:react/react.dart' as react;

var Label = react.registerComponent(() => new _Label());

class _Label extends react.Component {
  @override
  getDefaultProps() => {'labelType': 'label-danger'};

  render() {
    return react.span({'className': 'label ${props['labelType']}'}, props['text']);
  }
}
