import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';

class RowNode extends Node {
  RowNode({super.key})
      : super(
          name: 'Row',
          args: const {},
          builder: (args, children) {
            return Row(
              crossAxisAlignment: args['crossAxisAlignment'] ?? CrossAxisAlignment.center,
              mainAxisAlignment: args['mainAxisAlignment'] ?? MainAxisAlignment.start,
              mainAxisSize: args['mainAxisSize'] ?? MainAxisSize.max,
              textBaseline: args['textBaseline'],
              textDirection: args['textDirection'],
              verticalDirection: args['verticalDirection'] ?? VerticalDirection.down,
              key: args['key'],
              children: children ?? [],
            );
          },
        );
}
