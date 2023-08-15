import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../models/node.dart';
import '../models/registerer.dart';

class InspectorProvider extends ChangeNotifier {
  GlobalKey key = GlobalKey();

  late final root = Node(
      key: key,
      type: Scaffold,
      builder: (args, children) {
        return Registerer.build(
          Scaffold,
          args: {
            "appBar": Registerer.build(
              AppBar,
              isTarget: true,
              args: {
                "title": Registerer.build(
                  Text,
                  isTarget: false,
                  args: {
                    "text": "AppBar",
                  },
                ),
              },
            )
          },
          treeNode: tree,
        );
      });

  TreeNode tree = TreeNode(
    value: Scaffold,
    children: [
      TreeNode(
        value: AppBar,
        children: [
          TreeNode(
            value: Text,
            name: "AppBar",
            children: [],
          ),
        ],
      ),
    ],
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

  addNode({
    required TreeNode node,
    required TreeNode parent,
    Node? parentWidgetNode,
    Widget? widgetNode,
  }) {
    parent.children.add(node);
    node.parent = parent;
    node.parentWidgetNode = parentWidgetNode;
    node.widgetNode = widgetNode;
    updateTree();
  }
}

class TreeNode {
  final dynamic value;
  final String name;
  TreeNode? parent;
  Node? parentWidgetNode;
  Widget? widgetNode;

  List<TreeNode> children;
  FocusScopeNode focusNode = FocusScopeNode(
    skipTraversal: true,
  );

  TreeNode({required this.value, required this.children, this.name = ""});

  @override
  String toString() {
    return 'TreeNode{nodes: $children}';
  }

  removeChild(TreeNode node) {
    children.remove(node);
  }

  remove() {
    parent?.removeChild(this);
    print("parentWidgetNode has : ${parentWidgetNode?.children?.length}");
    print("parentWidgetNode on remove: ${parentWidgetNode?.onRemove}");
    parentWidgetNode?.children?.remove(widgetNode);
    parentWidgetNode?.onRemove?.call();
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
