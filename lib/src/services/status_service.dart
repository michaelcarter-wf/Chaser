library wChaser.src.services.alerts_service;

import 'dart:async';

class StatusService {
  StreamController _authStream;
  StreamController _alertStream;
  StreamController updateStreams;

  Stream<bool> auth;
  Stream<dynamic> alerts;

  String currentAlert;
  bool _authed = false;

  StatusService() {
    _alertStream = new StreamController<String>();
    _authStream = new StreamController<bool>();

    auth = _authStream.stream.asBroadcastStream();
    alerts = _alertStream.stream.asBroadcastStream();
  }

  bool get authed => _authed;
  set authed(bool authed) {
    if (_authed != authed) {
      _authed = authed;
      _authStream.add(_authed);
      _authed ? throwAlert('') : throwAlert('User is not authed');
    }
  }

  throwAlert(dynamic alertContent) {
    if (currentAlert != alertContent) {
      currentAlert = alertContent;
      _alertStream.add(currentAlert);
    }
  }
}
