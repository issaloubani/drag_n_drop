import 'package:flutter/material.dart';

import '../models/node.dart';
import '../models/registerer.dart';

class InspectorProvider extends ChangeNotifier {
  final root = Node(builder: (args, children) {
    return Registerer.build(Container, args: {
      "color": Colors.blue,
    });
  });
}
