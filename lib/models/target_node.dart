import 'package:flutter/material.dart';

class TargetNode<T extends Object> extends StatefulWidget {
  final Widget child;
  final void Function(T data)? onAccept;

  const TargetNode({super.key, required this.child, this.onAccept});

  @override
  State<TargetNode<T>> createState() => _TargetNodeState<T>();

  TargetNode copyWith({
    final Widget? child,
    final void Function(T data)? onAccept,
  }) {
    return TargetNode<T>(
      onAccept: onAccept ?? this.onAccept,
      child: child ?? this.child,
    );
  }
}

class _TargetNodeState<T extends Object> extends State<TargetNode<T>> {
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

  _TargetNodeState copyWith() {
    return _TargetNodeState();
  }
}
