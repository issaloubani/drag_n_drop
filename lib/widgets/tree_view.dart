import 'package:drag_n_drop/providers/theme_provider.dart';
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
        return TreeIndentation(
          entry: entry,
          guide: IndentGuide.connectingLines(
            color: context.read<ThemeProvider>().selectedTheme.theme?.colorScheme.background ?? Colors.black,
            thickness: 1,
          ),
          child: Row(
            children: [
              if (entry.node.children?.isNotEmpty ?? false)
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
              const SizedBox(width: 8),
              Text(entry.node.name),
              if (entry.node.parent != null) ...[
                IconButton(
                  onPressed: () => _onViewPressed(entry.node),
                  icon: const Icon(Icons.remove_red_eye),
                  iconSize: 16,
                  splashRadius: 18,
                ),
                IconButton(
                  onPressed: () => _onDeletePressed(entry.node),
                  icon: const Icon(Icons.delete),
                  iconSize: 16,
                  splashRadius: 18,
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  _onDeletePressed(Node node) {
    node.parent!.removeNode(node);
    provider
      ..updateTree()
      ..treeController.rebuild();
    // check if selected widget is the same
    if (provider.selectedWidget?.sameAs(node) ?? false) {
      provider.setSelectedWidget(null);
      return;
    }
    // check if the selected widget is a child of the deleted node
    if (node.contains(provider.selectedWidget) ?? false) {
      provider.setSelectedWidget(null);
    }
  }

  _onViewPressed(Node node) {
    provider.setSelectedWidget(node);
  }

  _onExpandPressed(Node node) {
    provider.treeController.toggleExpansion(node);
    provider.treeController.rebuild();
  }
}
