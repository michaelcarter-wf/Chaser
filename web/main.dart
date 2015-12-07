import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/chaser_container.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/services/github.dart';

main() {
  reactClient.setClientConfiguration();

  ChaserActions chaserActions = new ChaserActions();
  ChaserStores chaserStores = new ChaserStores(chaserActions, new GitHubService());

//  react.render(ChaserContainer({
//      'store': chaserStores,
//      'actions': chaserActions,
//  }), querySelector('#output'));



}
