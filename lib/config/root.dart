import 'package:flutter/material.dart';

import '../models/node.dart';
import '../models/registerer.dart';

GlobalKey key = GlobalKey();

final editScreenRoot = getRootNode();

Node getRootNode() {
  final appBar = Registerer.build(AppBar, args: {});
  final body = Registerer.build(Container, args: {});

  final scaffold = Registerer.build(
    Scaffold,
    args: {
      'appBar': appBar,
      'body': body,
    },
    isTarget: false,
  );
  scaffold.children = [appBar, body];
  return scaffold;
}
