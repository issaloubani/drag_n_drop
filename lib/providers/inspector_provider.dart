import 'package:drag_n_drop/widgets/editor_screen.dart';
import 'package:drag_n_drop/widgets/target_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../config/root.dart';
import '../models/node.dart';

class InspectorProvider extends ChangeNotifier {
  TreeNode treeRoot = treeRootNode;
  GlobalKey<EditScreenState> editScreenKey = GlobalKey<EditScreenState>();

  TreeNode? selectedWidget;
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

  void setSelectedWidget(TreeNode? node) {
    if (node == null) {
      print('widget is null, please check this out');
      return;
    }

    selectedWidget = node;
    notifyListeners();
  }

  editScreenScaleUp() {
    editScreenKey.currentState?.scaleUp();
  }

  editScreenScaleDown() {
    editScreenKey.currentState?.scaleDown();
  }

  void updateWidget(Map<String, dynamic> args) {
    if (selectedWidget == null) {
      print('selectedWidget is null, please check this out');
      return;
    }
    Node? node;
    final nodeToBeUpdated = selectedWidget?.widgetNode;

    if (nodeToBeUpdated is Node) {
      node = nodeToBeUpdated;
    } else if (nodeToBeUpdated is TargetNode) {
      node = (nodeToBeUpdated).node;
    }
    node = node?.copyWith(args: args);
    selectedWidget?.update(node, args);
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

  update(Node? newWidgetNode, Map<String, dynamic> args) {
    print("Size of children before : ${parentWidgetNode?.children?.length}");
    parentWidgetNode?.children?.removeWhere((element) {
      return (element as Node).name == newWidgetNode?.name;
    });
    print("Size of children after: ${parentWidgetNode?.children?.length}");
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
