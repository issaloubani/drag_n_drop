import 'package:drag_n_drop/config/supported_items.dart';
import 'package:drag_n_drop/models/tree_node.dart';
import 'package:drag_n_drop/widgets/target_node.dart';
import 'package:flutter/material.dart';

import 'node.dart';

class Registerer {
  static final Map<Type, Node> registeredItems = supportedItems;

  static Node get(Type type) {
    if (registeredItems.containsKey(type)) {
      return registeredItems[type]!;
    } else {
      throw Exception('Type $type is not supported');
    }
  }

  static Widget build(Type type, {bool isTarget = true, Map<String, dynamic>? args, TreeNode? treeNode}) {
    var node = get(type);
    node = node.copyWith(args: args, type: type);

    if (isTarget) {
      return TargetNode(
        node: node,
        parent: treeNode,
      );
    }

    return node;
  }
}
