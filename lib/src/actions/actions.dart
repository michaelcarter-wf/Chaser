library wChaser.src.actions;

import 'package:w_flux/w_flux.dart';

class AtMentionActions {
  static final String NAME = 'atMentionActions';
  Action refreshView = new Action();
  Action<bool> displayAll = new Action<bool>();
}
