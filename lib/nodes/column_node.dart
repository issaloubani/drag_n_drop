import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';

class ColumnNode extends Node {
  ColumnNode({super.key})
      : super(
          name: 'Column',
          builder: (args, children) {
            return Column(
              crossAxisAlignment: args['crossAxisAlignment'] ?? CrossAxisAlignment.center,
              mainAxisAlignment: args['mainAxisAlignment'] ?? MainAxisAlignment.start,
              mainAxisSize: args['mainAxisSize'] ?? MainAxisSize.max,
              textBaseline: args['textBaseline'],
              textDirection: args['textDirection'],
              verticalDirection: args['verticalDirection'] ?? VerticalDirection.down,
              children: children ?? [],
            );
          },
        );
}
