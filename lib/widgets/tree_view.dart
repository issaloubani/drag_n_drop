import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class TreeView extends StatefulWidget {
  final SingleParentNode root;

  const TreeView({super.key, required this.root});

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late final treeController;

  @override
  void initState() {
    super.initState();
    treeController = TreeController(
      roots: [widget.root],
      childrenProvider: (SingleParentNode node) {
        return node.child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTreeView(treeController: treeController, nodeBuilder: nodeBuilder);
  }
}
