import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';

class ScaffoldNode extends Node {
  ScaffoldNode({super.key})
      : super(
          name: 'Scaffold',
          args: const {},
          builder: (args, children) {
            return Scaffold(
              appBar: args['appBar'],
              body: args['body'],
              backgroundColor: args['backgroundColor'],
              bottomNavigationBar: args['bottomNavigationBar'],
            );
          },
        );
}
