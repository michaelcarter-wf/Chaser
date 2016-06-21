import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react_dom.dart' as react_dom;

import 'package:wChaser/src/components/chaser_app.dart';
import 'package:wChaser/src/services/local_storage.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/actions/actions.dart';

main() async {
  reactClient.setClientConfiguration();
  LocationStorageService locationStorageService = new LocationStorageService();
  await locationStorageService.load();

  ChaserActions chaserActions = new ChaserActions();
  ChaserStores chaserStores = new ChaserStores(chaserActions, locationStorageService);

  react_dom.render(ChaserApp({'store': chaserStores, 'actions': chaserActions}), querySelector('#output'));
}
