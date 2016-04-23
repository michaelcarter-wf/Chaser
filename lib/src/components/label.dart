import 'package:react/react.dart' as react;

var Label = react.registerComponent(() => new _Label());

class _Label extends react.Component {
  render() {
    return react.span({'className': 'label label-danger'}, props['text']);
  }
}
