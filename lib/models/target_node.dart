import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inspector_provider.dart';
import 'node.dart';
import 'registerer.dart';
import 'widget_data.dart';

class DragTargetNode<T extends Object> extends StatefulWidget {
  final Widget child;
  final void Function(T data)? onAccept;

  const DragTargetNode({super.key, required this.child, this.onAccept});

  @override
  State<DragTargetNode<T>> createState() => _DragTargetNodeState<T>();

  DragTargetNode copyWith({
    final Widget? child,
    final void Function(T data)? onAccept,
  }) {
    return DragTargetNode<T>(
      onAccept: onAccept ?? this.onAccept,
      child: child ?? this.child,
    );
  }
}

class _DragTargetNodeState<T extends Object> extends State<DragTargetNode<T>> {
  Color color = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onAccept: (data) {
        setState(() {
          color = Colors.transparent;
        });
        widget.onAccept?.call(data);
      },
      onWillAccept: (data) {
        if (data == null) {
          setState(() {
            color = Colors.red;
          });
          return false;
        }

        setState(() {
          color = Colors.green;
        });

        return true;
      },
      onLeave: (data) {
        setState(() {
          color = Colors.transparent;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: color,
            width: 2,
          )),
          child: widget.child,
        );
      },
    );
  }

  _DragTargetNodeState copyWith() {
    return _DragTargetNodeState();
  }
}

class TargetNode extends StatefulWidget {
  Node node;
  TreeNode? parent;

  TargetNode({super.key, required this.node, this.parent});

  @override
  State<TargetNode> createState() => _TargetNodeState();
}

class _TargetNodeState extends State<TargetNode> {
  bool showToolbar = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        Expanded(
          child: StatefulBuilder(
            builder: (context, setState) {
              return DragTargetNode<WidgetData>(
                onAccept: (WidgetData data) {
                  final children = widget.node.children ?? [];
                  TreeNode? treeNode;

                  if (widget.parent != null) {
                    treeNode = TreeNode(
                      value: data.type,
                      children: [],
                    );
                    context.read<InspectorProvider>().addNode(
                          node: treeNode,
                          parent: widget.parent!,
                        );
                  }
                  children.add(Registerer.build(data.type, args: data.args, treeNode: treeNode));

                  setState(() {
                    widget.node = widget.node.copyWith(children: children);
                  });
                },
                child: widget.node,
              );
            },
          ),
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
    );
  }
}
