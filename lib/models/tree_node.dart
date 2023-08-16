import 'package:drag_n_drop/widgets/target_node.dart';
import 'package:flutter/material.dart';

import 'node.dart';

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
    parentWidgetNode?.children?.removeWhere((element) {
      if (element is TargetNode) {
        return (element).node?.name == (widgetNode as Node).name;
      }
      return (element as Node).name == (widgetNode as Node).name;
    });
    parentWidgetNode?.onRemove?.call();
  }

  update(Node? newWidgetNode, Map<String, dynamic> args) {
    parentWidgetNode?.children?.removeWhere((element) {
      if (element is TargetNode) {
        return (element).node?.name == (newWidgetNode as Node).name;
      }
      return (element as Node).name == newWidgetNode?.name;
    });
    parentWidgetNode?.children?.add(newWidgetNode!);
    parentWidgetNode?.onUpdate?.call(args);
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
