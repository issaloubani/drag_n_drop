import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';

class AppBarNode extends Node {
  AppBarNode({super.key})
      : super(
          name: 'AppBar',
          args: const {
            'title': Text('AppBar'),
          },
          builder: (args, children) {
            return AppBar(
              title: (children != null && children.isNotEmpty ? children.first : null) ?? args['title'],
            );
          },
        );
}
