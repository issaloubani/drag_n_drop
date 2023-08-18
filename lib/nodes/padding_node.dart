import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';

class PaddingNode extends Node {
  PaddingNode({super.key})
      : super(
          name: 'Padding',
          args: const {
            'padding': EdgeInsets.all(8.0),
          },
          supportedParameters: const {
            'padding': EdgeInsets,
          },
          builder: (args, children) {
            return Padding(
              padding: args['padding'],
              child: (children != null && children.isNotEmpty) ? children.first : null,
            );
          },
        );
}
