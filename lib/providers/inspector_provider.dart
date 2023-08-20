import 'package:drag_n_drop/widgets/editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../config/root.dart';
import '../models/node.dart';

enum InspectorMode { edit, preview }

class InspectorProvider extends ChangeNotifier {
  GlobalKey<EditScreenState> editScreenKey = GlobalKey<EditScreenState>();
  InspectorMode inspectorMode = InspectorMode.edit;

  Node editScreenWidget = editScreenRoot.copyWith();
  Node? selectedWidget;

  late final TreeController<Node> treeController = TreeController<Node>(
    roots: [
      editScreenRoot,
    ],
    childrenProvider: (Node node) => node.children ?? [],
  );

  updateTree() {
    // _debugPrintNodeTree();
    editScreenWidget = editScreenWidget.copyWith();
    treeController.expandAll();
    notifyListeners();
  }

  _debugPrintNodeTree() {
    _printNode(editScreenWidget);
  }

  _printNode(Node node) {
    print("Node id : ${node.id}");
    if (node.children != null) {
      for (final child in node.children!) {
        _printNode(child);
      }
    }
  }

  void setSelectedWidget(Node? node) {
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
      return;
    }
    selectedWidget?.updateArgs(args);
    updateTree();
  }

  void editScreenResetLocation() {
    editScreenKey.currentState?.reset();
  }

  void editScreenRefresh() {
    editScreenKey.currentState?.refresh();
  }

  void setMode(InspectorMode mode) {
    inspectorMode = mode;
    notifyListeners();
  }
}
