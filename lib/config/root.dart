import 'package:flutter/material.dart';

import '../models/registerer.dart';
import '../models/tree_node.dart';

GlobalKey key = GlobalKey();

final editScreenRoot = getRootNode();

TreeNode treeRootNode = TreeNode(
  value: Scaffold,
  name: 'Scaffold',
  children: [],
);

Widget getRootNode() {
  final appBarNode = TreeNode(
    value: AppBar,
    children: [],
  );
  final bodyNode = TreeNode(
    value: Container,
    name: 'Body',
    children: [],
  );

  final appBar = Registerer.build(AppBar, args: {}, treeNode: appBarNode);
  final body = Registerer.build(Container, args: {}, treeNode: bodyNode);

  final scaffold = Registerer.build(
    Scaffold,
    args: {
      'appBar': appBar,
      'body': body,
    },
    isTarget: false,
  );
  treeRootNode.children.addAll(
    [
      appBarNode,
      bodyNode,
    ],
  );
  treeRootNode.copyWith(
    widgetNode: scaffold,
  );
  return scaffold;
}
