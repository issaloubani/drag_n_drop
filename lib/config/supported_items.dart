import 'package:drag_n_drop/widgets/target_node.dart';
import 'package:flutter/material.dart';

import '../models/node.dart';

final Map<Type, Node> supportedItems = {
  TargetNode: Node(
    builder: (args, children) {
      return TargetNode(
        node: args['node'] ?? Container(),
        parent: args['parent'],
      );
    },
  ),
  AppBar: Node(
    args: const {
      'title': Text('AppBar'),
    },
    builder: (args, children) {
      return AppBar(
        title: (children != null && children.isNotEmpty ? children.first : null) ?? args['title'],
      );
    },
  ),
  Scaffold: Node(
    builder: (args, children) {
      return Scaffold(
        appBar: args['appBar'],
        body: args['body'],
        backgroundColor: args['backgroundColor'],
        bottomNavigationBar: args['bottomNavigationBar'],
      );
    },
  ),
  TextField: Node(
    builder: (args, children) {
      return TextField();
    },
  ),
  Row: Node(
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
  ),
  Text: Node(
    args: const {
      'text': 'Text',
    },
    builder: (args, children) {
      return Text(
        args['text'],
        style: args['style'],
      );
    },
  ),
  Container: Node(
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
  ),
  Column: Node(
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
  ),
};