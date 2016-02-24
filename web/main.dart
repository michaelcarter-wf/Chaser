import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/chaser_app.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/actions/actions.dart';

main() {
  reactClient.setClientConfiguration();

  ChaserActions chaserActions = new ChaserActions();
  ChaserStores chaserStores = new ChaserStores(chaserActions);

  react.render(ChaserApp({'store': chaserStores, 'actions': chaserActions}), querySelector('#output'));
}
