import 'dart:html';
import 'dart:async';

import 'package:lawndart/lawndart.dart' show LocalStorageStore;
import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/chaser_container.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/constants.dart';
import 'package:wChaser/src/services/github.dart';

void main() async{
  reactClient.setClientConfiguration();

  ChaserActions chaserActions = new ChaserActions();
  ChaserStores chaserStores = new ChaserStores(chaserActions, new GitHubService());

  react.render(ChaserContainer({
      'store': chaserStores,
      'actions': chaserActions,
  }), querySelector('#output'));

}
