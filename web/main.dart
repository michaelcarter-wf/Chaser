import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/chaser_app.dart';
import 'package:wChaser/src/services/local_storage.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/actions/actions.dart';

main() async {
  reactClient.setClientConfiguration();
  LocalStorageService localStorageService = new LocalStorageService();
  await localStorageService.load();

  ChaserActions chaserActions = new ChaserActions();
  ChaserStores chaserStores = new ChaserStores(chaserActions, localStorageService);

  react.render(ChaserApp({'store': chaserStores, 'actions': chaserActions}), querySelector('#output'));
}
