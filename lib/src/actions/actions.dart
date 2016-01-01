library wChaser.src.actions;

import 'package:w_flux/w_flux.dart';

class AtMentionActions {
  static final String NAME = 'atMentionActions';
  Action<bool> displayAll = new Action<bool>();
}

class AuthActions {
  static final String NAME = 'authActions';
  final Action<String> auth = new Action<String>();
  final Action<bool> authSuccessful = new Action<bool>();
}

class LocationActions {
  final Action refreshView = new Action();
  final Action changeViewPrevious = new Action();
  final Action changeViewNext = new Action();
}

class PopoverProps {
  PopoverProps(this.pageX, this.pageY, this.id, this.content);
  int pageX;
  int pageY;
  String id;
  dynamic content;
}

class PopoverActions {
  final Action<PopoverProps> showPopover = new Action<PopoverProps>();
  final Action closePopover = new Action();
}

class ChaserActions {
  AtMentionActions atMentionActions = new AtMentionActions();
  AuthActions authActions = new AuthActions();
  LocationActions locationActions = new LocationActions();
  PopoverActions popoverActions = new PopoverActions();
}
