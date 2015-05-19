// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart';

import 'components/header.dart' show Header;

void main() {
  reactClient.setClientConfiguration();
  var component = div({"className": "somehing"}, [
    h1({}, "Big Time Headline"),
    Header({}),
  ]);

  render(component, querySelector('#output'));
//  querySelector('#output').text = 'Your Dart app is running.';
}
