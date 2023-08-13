import 'package:drag_n_drop/models/target_node.dart';
import 'package:drag_n_drop/models/widget_data.dart';
import 'package:flutter/material.dart';

import 'node.dart';

class Registerer {
  static final Map<Type, Widget> supportedTypes = {
    Text: SterileNode(
      args: const {
        'text': 'Text',
      },
      builder: (args) {
        return Text(
          args['text'],
          style: args['style'],
        );
      },
    ),
    Container: SingleParentNode(
      args: const {
        "color": Colors.red,
      },
      builder: (args, child) {
        return Container(
          color: args['color'],
          width: args['width'],
          height: args['height'],
          child: child,
        );
      },
    ),
    Column: MultiParentNode(
      builder: (args, children) {
        return Column(
          crossAxisAlignment: args['crossAxisAlignment'] ?? CrossAxisAlignment.center,
          mainAxisAlignment: args['mainAxisAlignment'] ?? MainAxisAlignment.start,
          mainAxisSize: args['mainAxisSize'] ?? MainAxisSize.max,
          textBaseline: args['textBaseline'],
          textDirection: args['textDirection'],
          verticalDirection: args['verticalDirection'] ?? VerticalDirection.down,
          children: children ?? [],
        );
      },
    ),
  };

  static Widget get(Type type) {
    if (supportedTypes.containsKey(type)) {
      return supportedTypes[type]!;
    } else {
      throw Exception('Type $type is not supported');
    }
  }

  static Widget build(Type type, {bool isTarget = true, Map<String, dynamic>? args}) {
    var widget = get(type);

    if (widget is Node) {
      widget = widget.copyWith(args: args);
    } else {
      throw Exception('Type $type is not supported');
    }

    if (isTarget) {
      return StatefulBuilder(
        builder: (context, setState) {
          return TargetNode<WidgetData>(
            onAccept: (WidgetData data) {
              if (widget is SingleParentNode) {
                setState(() {
                  widget = (widget as SingleParentNode).copyWith(
                    child: build(data.type, args: data.args),
                  );
                });
              } else if (widget is MultiParentNode) {
                setState(() {
                  widget = (widget as MultiParentNode).copyWith(
                    children: [...(widget as MultiParentNode).children ?? [], build(data.type, args: data.args)],
                  );
                });
              }
            },
            child: widget,
          );
        },
      );
    }

    return widget;
  }
}
