library src.components.loading;

import 'package:react/react.dart' as react;

var Loading = react.registerComponent(() => new _Loading());

class _Loading extends react.Component {
  render() {
    return react.div({'className': 'text-center', 'style': {'margin': '154px'}}, [
        react.img({
          'className': 'text-center github-title pointer',
          'src': '/packages/wChaser/images/octocat-spinner-32.gif',
        })
      ]);
  }
}
