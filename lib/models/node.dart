import 'package:flutter/material.dart';

abstract class Node extends StatelessWidget {
  const Node({super.key});

  @override
  Widget build(BuildContext context);

  Node copyWith({Map<String, dynamic>? args});
}

class SingleParentNode extends Node {
  final Widget Function(Map<String, dynamic> args, Widget? child) builder;
  final Map<String, dynamic> args;
  Widget? child;

  SingleParentNode({super.key, required this.builder, this.args = const {}});

  @override
  Widget build(BuildContext context) {
    return builder.call(args, child);
  }

  @override
  SingleParentNode copyWith({
    final Widget Function(Map<String, dynamic> args, Widget? child)? builder,
    final Map<String, dynamic>? args,
    Widget? child,
  }) {
    final widget = SingleParentNode(
      builder: builder ?? this.builder,
      args: args ?? this.args,
    );
    widget.child = child ?? this.child;
    return widget;
  }
}

class MultiParentNode extends Node {
  final Widget Function(Map<String, dynamic> args, List<Widget>? children) builder;
  final Map<String, dynamic> args;
  List<Widget>? children;

  MultiParentNode({super.key, required this.builder, this.args = const {}});

  @override
  Widget build(BuildContext context) {
    return builder.call(args, children);
  }

  @override
  MultiParentNode copyWith({
    final Widget Function(Map<String, dynamic> args, List<Widget>? children)? builder,
    final Map<String, dynamic>? args,
    List<Widget>? children,
  }) {
    final widget = MultiParentNode(
      builder: builder ?? this.builder,
      args: args ?? this.args,
    );
    widget.children = children ?? this.children;
    return widget;
  }
}

class SterileNode extends Node {
  Widget Function(Map<String, dynamic> args) builder;
  final Map<String, dynamic> args;

  SterileNode({super.key, required this.builder, this.args = const {}});

  @override
  Widget build(BuildContext context) {
    return builder.call(args);
  }

  @override
  SterileNode copyWith({
    final Widget Function(Map<String, dynamic> args)? builder,
    final Map<String, dynamic>? args,
  }) {
    final widget = SterileNode(
      builder: builder ?? this.builder,
      args: args ?? this.args,
    );
    return widget;
  }
}
