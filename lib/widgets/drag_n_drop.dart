import 'package:drag_n_drop/providers/inspector_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_tree/flutter_tree.dart';
import 'package:provider/provider.dart';

import '../models/node.dart';
import '../models/widget_data.dart';
import 'draggable_content.dart';

class DragNDrop extends StatefulWidget {
  const DragNDrop({super.key});

  @override
  State<DragNDrop> createState() => _DragNDropState();
}

class _DragNDropState extends State<DragNDrop> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<InspectorProvider>().updateTree();
    });
  }

  Widget buildTree() {
    return context.read<InspectorProvider>().root;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Selector<InspectorProvider, TreeNode>(
          builder: (context, value, child) {
            print("tree widget was built");
            final provider = context.read<InspectorProvider>();
            return Expanded(
              flex: 2,
              child: AnimatedTreeView<TreeNode>(
                treeController: provider.treeController,
                nodeBuilder: (BuildContext context, TreeEntry<TreeNode> entry) {
                  return InkWell(
                    onTap: () => provider.treeController.toggleExpansion(entry.node),
                    child: TreeIndentation(
                      entry: entry,
                      guide: const IndentGuide.scopingLines(),
                      child: Text(entry.node.value.toString()),
                    ),
                  );
                },
              ),
            );
          },
          selector: (context, provider) => provider.tree,
        ),
        Expanded(
          flex: 4,
          child: buildTree(),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Debug"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Refresh"),
                ),
                DraggableContent<WidgetData>(
                  data: WidgetData(
                    type: Text,
                    args: {
                      "text": "Label",
                    },
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Label"),
                  ),
                ),
                DraggableContent<WidgetData>(
                  data: WidgetData(
                    type: Container,
                    args: {
                      "color": Colors.red,
                      "width": 100.0,
                      "height": 100.0,
                    },
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Container"),
                  ),
                ),
                DraggableContent<WidgetData>(
                  data: WidgetData(
                    type: Column,
                    args: {
                      "crossAxisAlignment": CrossAxisAlignment.start,
                      "mainAxisAlignment": MainAxisAlignment.start,
                    },
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Column"),
                  ),
                ),
                DraggableContent<WidgetData>(
                  data: WidgetData(
                    type: Row,
                    args: {
                      "crossAxisAlignment": CrossAxisAlignment.start,
                      "mainAxisAlignment": MainAxisAlignment.start,
                    },
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Row"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _printTree(TreeNodeData node) {
    print("Item $node, children length ${node.children.length}");
    for (final child in node.children) {
      _printTree(child);
    }
  }
}
