import 'package:flutter/material.dart';

import '../models/registerer.dart';
import '../models/widget_data.dart';
import 'draggable_content.dart';

class DragNDrop extends StatefulWidget {
  const DragNDrop({super.key});

  @override
  State<DragNDrop> createState() => _DragNDropState();
}

class _DragNDropState extends State<DragNDrop> {
  final root = Registerer.build(Container, args: {
    "color": Colors.blue,
  });

  Widget buildTree() {
    print('buildTree');
    return root;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.blueGrey,
            child: const Center(
              child: Text('Tree'),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: buildTree(),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: Center(
                child: Column(
              children: [
                DraggableContent<WidgetData>(
                  data: WidgetData(
                    type: Text,
                    args: {
                      "text": "Label",
                    },
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Label"),
                  ),
                ),
                DraggableContent<WidgetData>(
                  data: WidgetData(
                    type: Container,
                    args: {
                      "color": Colors.red,
                      "width": 100.0,
                      "height": 100.0,
                    },
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Container"),
                  ),
                ),
                DraggableContent<WidgetData>(
                  data: WidgetData(type: Column, args: {
                    "crossAxisAlignment": CrossAxisAlignment.start,
                    "mainAxisAlignment": MainAxisAlignment.start,
                  }),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Column"),
                  ),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}
