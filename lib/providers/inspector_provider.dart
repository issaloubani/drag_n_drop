import 'package:drag_n_drop/widgets/editor_screen.dart';
import 'package:drag_n_drop/widgets/target_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../config/root.dart';
import '../models/node.dart';
import '../models/tree_node.dart';

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
    selectedWidget = selectedWidget?.copyWith();
    updateTree();
  }

  void removeSelectedWidget(TreeNode node) {
    String? nodeId;
    String? selectedNodeId;
    if (node.widgetNode is Node) {
      nodeId = (node.widgetNode as Node).name;
    } else if (node.widgetNode is TargetNode) {
      nodeId = (node.widgetNode as TargetNode).node!.name;
    }

    if (selectedWidget?.widgetNode is Node) {
      selectedNodeId = (selectedWidget?.widgetNode as Node).name;
    } else if (selectedWidget?.widgetNode is TargetNode) {
      selectedNodeId = (selectedWidget?.widgetNode as TargetNode).node!.name;
    }

    if (nodeId == selectedNodeId) {
      selectedWidget = null;
    } else {
      return;
    }
    node.remove();
    updateTree();
  }

  void editScreenResetLocation() {
    editScreenKey.currentState?.reset();
  }
}
