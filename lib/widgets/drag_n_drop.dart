import 'package:drag_n_drop/generated/assets.dart';
import 'package:drag_n_drop/providers/inspector_provider.dart';
import 'package:drag_n_drop/widgets/drag_items_view.dart';
import 'package:drag_n_drop/widgets/toolbar.dart';
import 'package:drag_n_drop/widgets/tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'editor_screen.dart';

class DragNDrop extends StatefulWidget {
  const DragNDrop({super.key});

  @override
  State<DragNDrop> createState() => _DragNDropState();
}

class _DragNDropState extends State<DragNDrop> {
  double treeViewPer = 0.2;
  double dragItemsViewPer = 0.2;
  double editScreenPer = 0.6;

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
            return SizedBox(
              width: MediaQuery.of(context).size.width * treeViewPer,
              child: TreeView(),
            );
          },
          selector: (context, provider) => provider.tree,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * editScreenPer,
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.topCenter,
            children: [
              EditScreen(
                child: buildTree(),
              ),
              const Positioned(
                top: 0,
                child: ToolBar(),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * dragItemsViewPer,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              const DragItemsView(),

            ],
          ),
        ),
      ],
    );
  }
}
