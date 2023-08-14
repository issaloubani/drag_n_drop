import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class TreeView extends StatefulWidget {
  final Widget root;

  const TreeView({super.key, required this.root});

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late final TreeController treeController;

  @override
  void initState() {
    super.initState();
    treeController = TreeController<Widget>(
      roots: [widget.root],
      childrenProvider: (Widget node) {
        if (node is SingleParentNode && node.child != null) {
          return [node.child!];
        }
        if (node is MultiParentNode && node.children != null) {
          return node.children!;
        }
        return const Iterable.empty();
      },
    );
  }

  buildTree() {
    final currentNode = widget.root;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTreeView(
      treeController: treeController,
      nodeBuilder: (context, entry) {
        String text = "";

        return InkWell(
          onTap: () => treeController.toggleExpansion(entry.node),
          child: TreeIndentation(
            entry: entry,
            child: Text(text),
          ),
        );
      },
    );
  }
}
