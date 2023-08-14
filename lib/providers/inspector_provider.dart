import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_tree/flutter_tree.dart';

import '../models/node.dart';
import '../models/registerer.dart';

class InspectorProvider extends ChangeNotifier {
  GlobalKey key = GlobalKey();

  late final root = Node(
      key: key,
      type: Container,
      builder: (args, children) {
        return Registerer.build(
          Container,
          args: {
            "color": Colors.blue,
          },
          treeNode: tree,
        );
      });

  TreeNode tree = TreeNode(
    value: Container,
    children: [],
  );

  late final TreeController<TreeNode> treeController = TreeController<TreeNode>(
    roots: [
      tree,
    ],
    childrenProvider: (TreeNode node) => node.children,
  );

  updateTree() {
    tree = tree.copyWith();
    treeController.expandAll();
    notifyListeners();
  }

  addNode({required TreeNode node, required TreeNode parent}) {
    parent.children.add(node);
    updateTree();
  }
}

class TreeNode {
  final dynamic value;
  List<TreeNode> children;

  TreeNode({
    required this.value,
    required this.children,
  });

  TreeNodeData get data {
    List<TreeNodeData> list = [];
    for (final child in children) {
      list.add(child.data);
    }

    return TreeNodeData(
      title: value.toString(),
      expaned: true,
      checked: false,
      children: children.map((e) => e.data).toList(),
    );
  }

  @override
  String toString() {
    return 'TreeNode{nodes: $children}';
  }

  TreeNode copyWith({
    final dynamic value,
    List<TreeNode>? children,
  }) {
    return TreeNode(
      value: value ?? this.value,
      children: children ?? this.children,
    );
  }
}
