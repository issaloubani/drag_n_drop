import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:provider/provider.dart';

import '../models/node.dart';
import '../providers/inspector_provider.dart';

class TreeView extends StatefulWidget {
  const TreeView({
    super.key,
  });

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late final provider = context.read<InspectorProvider>();

  @override
  Widget build(BuildContext context) {
    return AnimatedTreeView<Node>(
      treeController: provider.treeController,
      nodeBuilder: (BuildContext context, TreeEntry<Node> entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _onExpandPressed(entry.node),
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
              child: Text(entry.node.name),
            ),
            if (entry.node.parent != null) ...[
              IconButton(
                onPressed: () => _onDeletePressed(entry.node),
                icon: const Icon(Icons.delete),
                iconSize: 16,
                splashRadius: 18,
              ),
              IconButton(
                onPressed: () => _onViewPressed(entry.node),
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

  _onDeletePressed(Node node) {
    node.parent!.removeNode(node);
    provider
      ..updateTree()
      ..treeController.rebuild();
    (provider.selectedWidget?.id == node.id) ? provider.setSelectedWidget(null) : null;
  }

  _onViewPressed(Node node) {
    provider.setSelectedWidget(node);
  }

  _onExpandPressed(Node node) {
    provider.treeController.toggleExpansion(node);
    provider.treeController.rebuild();
  }
}
