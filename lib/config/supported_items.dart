import 'package:flutter/material.dart';

import '../models/enum_type.dart';
import '../models/node.dart';

final Map<Type, Node> supportedItems = {
  AppBar: Node(
    name: 'AppBar',
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
    name: 'Scaffold',
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
    name: 'TextField',
    builder: (args, children) {
      return TextField();
    },
  ),
  Row: Node(
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
  ),
  Text: Node(
    name: 'Text',
    args: const {
      'text': 'Text',
    },
    canHaveChildren: false,
    supportedParameters: const {
      'text': String,
      'textAlign': EnumType<TextAlign>(
        type: TextAlign,
        values: TextAlign.values,
      ),
    },
    builder: (args, children) {
      return Text(
        args['text'],
        textAlign: args['textAlign'] ?? TextAlign.start,
        style: args['style'],
      );
    },
  ),
  Container: Node(
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
  ),
  Column: Node(
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
  ),
  Center: Node(
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
  ),
  Padding: Node(
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
  ),
};
