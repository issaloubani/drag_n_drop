import 'package:flutter/material.dart';

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
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignCenter,
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
