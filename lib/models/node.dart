import 'package:flutter/material.dart';

class Node extends StatelessWidget {
  final Widget Function(Map<String, dynamic> args, List<Widget>? children) builder;
  final Map<String, dynamic> args;
  final List<Widget>? children;

  const Node({super.key, this.args = const {}, required this.builder, this.children});

  @override
  Widget build(BuildContext context) {
    return builder(args, children);
  }

  Node copyWith({
    Map<String, dynamic>? args,
    Widget Function(Map<String, dynamic> args, List<Widget>? children)? builder,
    List<Widget>? children,
  }) {
    return Node(
      key: key,
      args: args ?? this.args,
      builder: builder ?? this.builder,
      children: children ?? this.children,
    );
  }
}
