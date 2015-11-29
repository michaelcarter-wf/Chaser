library wChaser.src.actions;

import 'package:w_flux/w_flux.dart';

class AtMentionActions {
  static final String NAME = 'atMentionActions';
  Action refresh = new Action();
  Action<bool> displayAll = new Action<bool>();
}
