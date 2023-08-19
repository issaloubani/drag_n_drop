import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';

class ContainerNode extends Node {
  ContainerNode({super.key})
      : super(
          name: 'Container',
          args: const {
            "color": Colors.red,
          },
          builder: (args, children) {
            return Container(
              color: args['color'],
              width: args['width'],
              height: args['height'],
              child: (children != null && children.isNotEmpty) ? children.first : null,
            );
          },
        );
}
