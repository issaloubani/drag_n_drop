import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:provider/provider.dart';

import '../models/node.dart';
import '../models/widget_data.dart';
import '../providers/inspector_provider.dart';
import '../providers/theme_provider.dart';
import 'drag_target_node.dart';

class TreeItem extends StatefulWidget {
  final TreeEntry<Node> entry;

  const TreeItem({super.key, required this.entry});

  @override
  State<TreeItem> createState() => _TreeItemState();
}

class _TreeItemState extends State<TreeItem> {
  late final provider = context.read<InspectorProvider>();
  late final themeProvider = context.read<ThemeProvider>();
  late final entry = widget.entry;

  @override
  Widget build(BuildContext context) {
    return TreeIndentation(
      entry: entry,
      guide: IndentGuide.connectingLines(
        color: context.read<ThemeProvider>().selectedTheme.theme?.colorScheme.background ?? Colors.black,
        thickness: 1,
      ),
      child: DragTargetNode<WidgetData>(
        onAccept: (data) {
          entry.node.onAccept(context, data);
        },
        child: Container(
          decoration: BoxDecoration(
            color: provider.selectedWidget?.sameAs(entry.node) ?? false
                ? themeProvider.isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[200]
                : null,
            borderRadius: BorderRadius.circular(8),
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
        ),
      ),
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
    provider.treeController.rebuild();
  }

  _onExpandPressed(Node node) {
    provider.treeController.toggleExpansion(node);
    provider.treeController.rebuild();
  }
}
