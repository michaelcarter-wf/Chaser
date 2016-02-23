import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/services/status_service.dart';
import 'package:wChaser/src/services/github.dart';
import 'package:wChaser/src/components/chaser_app.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/actions/actions.dart';

main() {
  reactClient.setClientConfiguration();

  ChaserActions chaserActions = new ChaserActions();
  StatusService statusService = new StatusService();
  GitHubService gitHubService = new GitHubService(statusService: statusService);
  ChaserStores chaserStores = new ChaserStores(chaserActions, gitHubService);

  react.render(ChaserApp({'store': chaserStores, 'actions': chaserActions, 'statusService': statusService}),
      querySelector('#output'));
}
