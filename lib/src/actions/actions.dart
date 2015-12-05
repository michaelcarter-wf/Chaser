library wChaser.src.actions;

import 'package:w_flux/w_flux.dart';

class AtMentionActions {
  static final String NAME = 'atMentionActions';
  Action<bool> displayAll = new Action<bool>();
}

class AuthActions {
  static final String NAME = 'authActions';
  final Action<String> auth = new Action<String>();
}

class LocationActions {
  final Action refreshView = new Action();
}

class ChaserActions {
  AtMentionActions atMentionActions = new AtMentionActions();
  AuthActions authActions = new AuthActions();
  LocationActions locationActions = new LocationActions();
}
