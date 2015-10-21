import 'dart:async';
import 'dart:html';

import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart' as react;

import 'package:wChaser/src/components/chaser_container.dart';
import 'package:wChaser/src/stores/at_mention_store.dart';

void main() async {
  reactClient.setClientConfiguration();
  react.render(ChaserContainer({'atMentionStore': new AtMentionStore()}), querySelector('#output'));
//  querySelector('#output').text = 'Your Dart app is running.';

}
