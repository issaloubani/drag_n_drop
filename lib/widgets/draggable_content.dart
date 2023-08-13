import 'package:flutter/material.dart';

class DraggableContent<T extends Object> extends StatefulWidget {
  final Widget child;
  final T data;

  const DraggableContent({super.key, required this.child, required this.data});

  @override
  State<DraggableContent<T>> createState() => _DraggableContentState<T>();
}

class _DraggableContentState<T extends Object> extends State<DraggableContent<T>> {
  @override
  Widget build(BuildContext context) {
    return Draggable<T>(
      data: widget.data,
      feedback: Material(
        child: Opacity(
          opacity: 0.5,
          child: widget.child,
        ),
      ),
      child: widget.child,
    );
  }
}
