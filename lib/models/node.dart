import 'package:flutter/material.dart';

class Node extends StatelessWidget {
  final Widget Function(Map<String, dynamic> args, List<Widget>? children) builder;
  final Map<String, dynamic> args;
  final List<Widget>? children;
  Function? onRemove;

  Type? type;

  Node({super.key, this.args = const {}, required this.builder, this.children, this.type, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return builder(args, children);
  }

  Node copyWith({
    Map<String, dynamic>? args,
    Widget Function(Map<String, dynamic> args, List<Widget>? children)? builder,
    List<Widget>? children,
    Type? type,
    Function? onRemove,
  }) {
    return Node(
      key: key,
      args: args ?? this.args,
      builder: builder ?? this.builder,
      type: type ?? this.type,
      onRemove: onRemove ?? this.onRemove,
      children: children ?? this.children,
    );
  }
}
