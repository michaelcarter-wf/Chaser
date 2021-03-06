library src.components.alerts;

import 'package:react/react.dart' as react;

import 'package:wChaser/src/services/status_service.dart';

var Alert = react.registerComponent(() => new _Alert());

class _Alert extends react.Component {
  StatusService get statusService => props['statusService'];
  String get alertText => state['alertText'];

  getInitialState() => {'alertText': ''};

  void componentDidMount() {
    statusService.alerts.listen((_) {});
    // statusService.alerts.listen((alertContent) {
    //   setState({'alertText': statusService.currentAlert});
    // });
  }

  render() {
    return react.div({'className': alertText.isEmpty ? '' : 'chaser-alert'}, [alertText]);
  }
}
