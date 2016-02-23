library wChaser.src.services.alerts_service;

import 'dart:async';

class StatusService {
  StreamController authStream;
  StreamController alertStream;
  StreamController updateStreams;

  String currentAlert;
  bool _authed = false;

  StatusService() {
    alertStream = new StreamController<String>();
    authStream = new StreamController<bool>();
  }

  bool get authed => _authed;
  set authed(bool authed) {
    if (_authed != authed) {
      _authed = authed;
      authStream.add(_authed);
      _authed ? throwAlert('') : throwAlert('User is not authed');
    }
  }

  throwAlert(dynamic alertContent) {
    if (currentAlert != alertContent) {
      currentAlert = alertContent;
      alertStream.add(currentAlert);
    }
  }
}
