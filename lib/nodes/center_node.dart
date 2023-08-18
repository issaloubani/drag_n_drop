import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';

class CenterNode extends Node {
  CenterNode({super.key})
      : super(
          name: 'Center',
          args: const {
            'heightFactor': 1.0,
            'widthFactor': 1.0,
          },
          supportedParameters: const {
            'heightFactor': double,
            'widthFactor': double,
          },
          builder: (args, children) {
            return Center(
              heightFactor: args['heightFactor'],
              widthFactor: args['widthFactor'],
              child: (children != null && children.isNotEmpty) ? children.first : null,
            );
          },
        );
}
