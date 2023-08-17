import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:provider/provider.dart';

import '../models/tree_node.dart';
import '../providers/inspector_provider.dart';

class TreeView extends StatefulWidget {
  const TreeView({
    super.key,
  });

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<InspectorProvider>();
    return AnimatedTreeView<TreeNode>(
      treeController: provider.treeController,
      nodeBuilder: (BuildContext context, TreeEntry<TreeNode> entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                provider.treeController.toggleExpansion(entry.node);
                entry.node.focusNode.requestFocus();
                provider.treeController.rebuild();
              },
              iconSize: 16,
              icon: provider.treeController.getExpansionState(entry.node)
                  ? const Icon(
                Icons.arrow_drop_down_rounded,
              )
                  : const Icon(
                Icons.arrow_drop_up_rounded,
              ),
              splashRadius: 18,
            ),
            TreeIndentation(
              entry: entry,
              child: Text(entry.node.name ?? entry.node.value.toString()),
            ),
            if (entry.node.parent != null) ...[
              IconButton(
                onPressed: () {
                  provider.removeSelectedWidget(entry.node);
                },
                icon: const Icon(Icons.delete),
                iconSize: 16,
                splashRadius: 18,
              ),
              IconButton(
                onPressed: () {
                  provider.setSelectedWidget(entry.node);
                },
                icon: const Icon(Icons.remove_red_eye),
                iconSize: 16,
                splashRadius: 18,
              )
            ]
          ],
        );
      },
    );
  }
}
