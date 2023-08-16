import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../config/root.dart';
import '../models/node.dart';
import '../models/registerer.dart';

class InspectorProvider extends ChangeNotifier {
  TreeNode treeRoot = treeRootNode;
  final editScreenWidget = editScreenRoot;

  late final TreeController<TreeNode> treeController = TreeController<TreeNode>(
    roots: [
      treeRoot,
    ],
    childrenProvider: (TreeNode node) => node.children,
  );

  updateTree() {
    treeRoot = treeRoot.copyWith();
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
  final String? name;
  TreeNode? parent;
  Node? parentWidgetNode;
  Widget? widgetNode;

  List<TreeNode> children;
  FocusScopeNode focusNode = FocusScopeNode(
    skipTraversal: true,
  );

  TreeNode({
    required this.value,
    required this.children,
    this.name,
    this.parent,
    this.parentWidgetNode,
    this.widgetNode,
  });

  @override
  String toString() {
    return 'TreeNode{nodes: $children}';
  }

  removeChild(TreeNode node) {
    children.remove(node);
  }

  remove() {
    parent?.removeChild(this);
    parentWidgetNode?.children?.remove(widgetNode);
    parentWidgetNode?.onRemove?.call();
  }

  TreeNode copyWith({
    final dynamic value,
    List<TreeNode>? children,
    String? name,
    TreeNode? parent,
    Node? parentWidgetNode,
    Widget? widgetNode,
  }) {
    return TreeNode(
      value: value ?? this.value,
      children: children ?? this.children,
      name: name ?? this.name,
      parent: parent ?? this.parent,
      parentWidgetNode: parentWidgetNode ?? this.parentWidgetNode,
      widgetNode: widgetNode ?? this.widgetNode,
    );
  }
}
