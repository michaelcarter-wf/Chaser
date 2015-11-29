import 'dart:async';
import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/chaser_container.dart';
import 'package:wChaser/src/stores/at_mention_store.dart';
import 'package:wChaser/src/actions/actions.dart';

void main() async {
  reactClient.setClientConfiguration();

  AtMentionActions atMentionActions = new AtMentionActions();

  react.render(ChaserContainer({
      AtMentionStore.NAME: new AtMentionStore(atMentionActions),
      AtMentionActions.NAME: atMentionActions,
  }), querySelector('#output'));
}
