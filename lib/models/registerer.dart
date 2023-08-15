import 'package:drag_n_drop/widgets/target_node.dart';
import 'package:drag_n_drop/models/widget_data.dart';
import 'package:drag_n_drop/providers/inspector_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'node.dart';

class Registerer {
  static final Map<Type, Node> supportedTypes = {
    AppBar: Node(
      args: const {
        'title': Text('AppBar'),
      },
      builder: (args, children) {
        return AppBar(
          title: children?.first ?? args['title'],
        );
      },
    ),
    Scaffold: Node(
      builder: (args, children) {
        return Scaffold(
          appBar: args['appBar'],
          body: args['body'] ?? children?.first,
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
          child: children?.first,
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

  static Node get(Type type) {
    if (supportedTypes.containsKey(type)) {
      return supportedTypes[type]!;
    } else {
      throw Exception('Type $type is not supported');
    }
  }

  static Widget build(Type type, {bool isTarget = true, Map<String, dynamic>? args, TreeNode? treeNode}) {
    var node = get(type);
    node = node.copyWith(args: args, type: type);

    if (isTarget) {
      return TargetNode(
        node: node,
        parent: treeNode,
      );
    }

    return node;
  }
}
