import 'package:drag_n_drop/config/supported_items.dart';

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

  static Node build(Type type, {bool isTarget = true, Map<String, dynamic>? args}) {
    var node = get(type);
    node = node.copyWith(
      args: args,
      type: type,
      id: node.generateId(),
    );
    return node;
  }
}
