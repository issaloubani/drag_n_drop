import 'package:drag_n_drop/models/registerer.dart';
import 'package:drag_n_drop/models/widget_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inspector_provider.dart';
import '../widgets/drag_target_node.dart';

class Node extends StatelessWidget implements PreferredSizeWidget {
  Type? type;
  String id;
  List<Node>? children;
  Node? parent;
  Function? setState;
  Map<String, dynamic> args;
  bool canHaveChildren;
  bool canBeViewed;
  String name;

  final Widget Function(Map<String, dynamic> args, List<Node>? children) builder;
  final Map<String, dynamic> supportedParameters;

  Node({
    super.key,
    this.args = const {},
    required this.builder,
    this.children,
    this.type,
    this.id = "",
    this.supportedParameters = const {},
    this.parent,
    this.canHaveChildren = true,
    this.canBeViewed = true,
    this.name = "",
  }) {
    generateId();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        this.setState = setState;
        return DragTargetNode<WidgetData>(
          onAccept: (WidgetData data) {
            onAccept(context, data);
          },
          child: builder(args, children),
        );
      },
    );
  }

  void onAccept(BuildContext context, WidgetData data) {
    context.read<InspectorProvider>()
      ..setSelectedWidget(add(data))
      ..updateTree();
    setState?.call(() {});
  }

  Node add(WidgetData data) {
    final node = Registerer.build(data.type, args: data.args);
    addNode(node);
    return node;
  }

  void remove(String nodeId) {
    int index = -1;
    // find index of node
    // then remove it from children and parent
    children?.forEach((element) {
      if (element.id == nodeId) {
        index = children!.indexOf(element);
      }
    });
    if (index != -1) {
      children?.removeAt(index);
    }
  }

  String generateId() {
    // random name
    id = "${type.toString()}${DateTime.now().millisecondsSinceEpoch}";
    return id;
  }

  void addNode(Node newNode) {
    final children = this.children ?? [];
    newNode.parent = this;
    children.add(newNode);
    this.children = children;
  }

  void removeNode(Node nodeToRemove) {
    remove(nodeToRemove.id);
    setState?.call(() {});
  }

  void updateArgs(Map<String, dynamic> args) {
    this.args = args;
    setState?.call(() {});
  }

  bool contains(Node? node) {
    if (sameAs(node)) {
      return true;
    }

    if (children != null) {
      for (final child in children!) {
        if (child.contains(node)) {
          return true;
        }
      }
    }

    return false;
  }

  bool sameAs(Node? node) {
    if (node == null) {
      return false;
    }
    return node.id == id;
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);

  Node copyWith({
    Type? type,
    String? id,
    List<Node>? children,
    Node? parent,
    final Widget Function(Map<String, dynamic> args, List<Node>? children)? builder,
    final Map<String, dynamic>? args,
    final Map<String, dynamic>? supportedParameters,
    bool? canHaveChildren,
    bool? canBeViewed,
    String? name,
  }) {
    return Node(
      name: name ?? this.name,
      type: type ?? this.type,
      id: id ?? this.id,
      parent: parent ?? this.parent,
      builder: builder ?? this.builder,
      args: {...args ?? this.args},
      supportedParameters: supportedParameters ?? this.supportedParameters,
      canHaveChildren: canHaveChildren ?? this.canHaveChildren,
      canBeViewed: canBeViewed ?? this.canBeViewed,
      children: [...?children ?? this.children],
    );
  }
}
