import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inspector_provider.dart';
import '../models/node.dart';
import '../models/registerer.dart';
import '../models/widget_data.dart';
import 'drag_target_node.dart';

class TargetNode extends StatefulWidget implements PreferredSizeWidget {
  Node? node;
  TreeNode? parent;

  TargetNode({super.key, this.node, this.parent});

  @override
  State<TargetNode> createState() => _TargetNodeState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _TargetNodeState extends State<TargetNode> {
  bool showToolbar = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: widget.parent?.focusNode,
      canRequestFocus: true,
      onFocusChange: (value) {},
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return DragTargetNode<WidgetData>(
                onAccept: (WidgetData data) {
                  if (widget.node == null) {
                    return;
                  }
                  /*
                  * On accept, we need to add the widget to the tree
                  * */
                  TreeNode? treeNode;
                  final children = widget.node!.children ?? [];
                  Widget? newWidget;
                  // first, we need to check if the widget has a parent
                  // if not then we need to add it to the root
                  if (widget.parent == null) {
                    // add the widget to the root
                    children.add(Registerer.build(data.type, args: data.args, treeNode: treeNode, isTarget: data.isTarget));
                    // update the tree
                    // use immutable data to update the tree
                    widget.node = widget.node!.copyWith(children: children);
                    setState(() {});
                    return;
                  }
                  // create a new tree node, and add it to the tree
                  treeNode = TreeNode(
                    value: data.type,
                    children: [],
                  );
                  // add the widget to the tree with tree node
                  newWidget = Registerer.build(data.type, args: data.args, treeNode: treeNode, isTarget: data.isTarget);
                  children.add(newWidget);
                  // add function on remove to be executed when the widget is removed
                  // update the tree using immutable data
                  widget.node = widget.node!.copyWith(
                    children: children,
                    onRemove: () {
                      widget.node = widget.node!.copyWith();
                      setState(() {});
                    },
                  );
                  // add the widget to the tree
                  context.read<InspectorProvider>().addNode(
                        node: treeNode,
                        parent: widget.parent!,
                        parentWidgetNode: widget.node,
                        widgetNode: newWidget,
                      );
                  setState(() {});
                },
                child: widget.node ?? Container(),
              );
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            width: 100,
            child: Visibility(
              visible: showToolbar,
              child: Container(
                height: 50,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
