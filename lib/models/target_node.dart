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

class TargetNode extends StatelessWidget {
  Node node;
  TreeNode? parent;

  TargetNode({super.key, required this.node, this.parent});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return DragTargetNode<WidgetData>(
          onAccept: (WidgetData data) {
            final children = node.children ?? [];
            TreeNode? treeNode;

            if (parent != null) {
              treeNode = TreeNode(
                value: data.type,
                children: [],
              );
              context.read<InspectorProvider>().addNode(
                    node: treeNode,
                    parent: parent!,
                  );

            }
            children.add(Registerer.build(data.type, args: data.args, treeNode: treeNode));

            setState(() {
              node = node.copyWith(children: children);
            });
          },
          child: node,
        );
      },
    );
  }
}
