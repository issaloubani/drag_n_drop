import 'package:flutter/material.dart';

class Node extends StatelessWidget {
  final Widget Function(Map<String, dynamic> args, List<Widget>? children) builder;
  final Map<String, dynamic> args;
  final List<Widget>? children;
  Function? onRemove;
  Function(Map<String, dynamic> args)? onUpdate;
  Type? type;
  String name;
  Node({super.key, this.args = const {}, required this.builder, this.children, this.type, this.onRemove, this.onUpdate, this.name = ""});
  @override
  Widget build(BuildContext context) {
    if(name.isEmpty){
      // random name
      name = "${type.toString()}${DateTime.now().millisecondsSinceEpoch}";
    }
    return builder(args, children);
  }

  Node copyWith({
    Map<String, dynamic>? args,
    Widget Function(Map<String, dynamic> args, List<Widget>? children)? builder,
    List<Widget>? children,
    Type? type,
    Function? onRemove,
    String? name,
    Function(Map<String, dynamic> args)? onUpdate,
  }) {
    return Node(
      key: key,
      args: {... args ?? this.args},
      builder: builder ?? this.builder,
      type: type ?? this.type,
      name: name ?? this.name,
      onRemove: onRemove ?? this.onRemove,
      onUpdate: onUpdate ?? this.onUpdate,
      children: children ?? this.children,
    );
  }
}
