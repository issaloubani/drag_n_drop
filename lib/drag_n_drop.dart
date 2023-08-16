import 'package:drag_n_drop/generated/assets.dart';
import 'package:drag_n_drop/providers/inspector_provider.dart';
import 'package:drag_n_drop/widgets/drag_items_view.dart';
import 'package:drag_n_drop/widgets/toolbar.dart';
import 'package:drag_n_drop/widgets/tree_view.dart';
import 'package:drag_n_drop/widgets/widget_inspector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'widgets/editor_screen.dart';

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
    return context.read<InspectorProvider>().editScreenWidget;
  }

  @override
  Widget build(BuildContext context) {
    return ResizableContainer(
      direction: Axis.horizontal,
      children: [
        ResizableChildData(
          startingRatio: treeViewPer,
          child: Selector<InspectorProvider, TreeNode>(
            builder: (context, value, child) {
              return Column(
                children: [
                  const Expanded(child: TreeView()),
                  Expanded(
                    child: Column(
                      children: [
                        AppBar(
                          title: Text(
                            'Inspector',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          elevation: 0,
                          toolbarHeight: 30,
                        ),
                        const SizedBox(height: 8),
                        Selector<InspectorProvider, Widget?>(
                          builder: (context, selectedWidget, child) {
                            return SelectedWidgetInspector(
                              selectedWidget: selectedWidget,
                            );
                          },
                          selector: (context, provider) => provider.selectedWidget,
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
            selector: (context, provider) => provider.treeRoot,
          ),
        ),
        ResizableChildData(
          startingRatio: editScreenPer,
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
        ResizableChildData(
          startingRatio: dragItemsViewPer,
          child: const Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              DragItemsView(),
            ],
          ),
        ),
      ],
    );
  }
}
