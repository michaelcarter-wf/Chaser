import 'dart:async';
import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/chaser_container.dart';
import 'package:wChaser/src/stores/at_mention_store.dart';
import 'package:wChaser/src/actions/actions.dart';

void main() async {
  reactClient.setClientConfiguration();

  ChaserActions chaserActions = new ChaserActions();

  react.render(ChaserContainer({
      AtMentionStore.NAME: new AtMentionStore(chaserActions.atMentionActions),
      'actions': new ChaserActions(),
  }), querySelector('#output'));
}
