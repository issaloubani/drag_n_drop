import 'package:drag_n_drop/widgets/tree_item.dart';
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
    return GestureDetector(
      onTap: () {
        provider.setSelectedWidget(null);
        provider.updateTree();
      },
      child: AnimatedTreeView<Node>(
        treeController: provider.treeController,
        nodeBuilder: (BuildContext context, TreeEntry<Node> entry) {
          return TreeItem(
            entry: entry,
          );
        },
      ),
    );
  }
}
