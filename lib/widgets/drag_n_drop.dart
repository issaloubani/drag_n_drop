import 'package:drag_n_drop/providers/inspector_provider.dart';
import 'package:drag_n_drop/widgets/toolbar.dart';
import 'package:drag_n_drop/widgets/tree_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/widget_data.dart';
import 'draggable_content.dart';

class DragNDrop extends StatefulWidget {
  const DragNDrop({super.key});

  @override
  State<DragNDrop> createState() => _DragNDropState();
}

class _DragNDropState extends State<DragNDrop> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<InspectorProvider>().updateTree();
    });
  }

  Widget buildTree() {
    return context.read<InspectorProvider>().root;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Selector<InspectorProvider, TreeNode>(
          builder: (context, value, child) {
            return const Expanded(
              flex: 2,
              child: TreeView(),
            );
          },
          selector: (context, provider) => provider.tree,
        ),
        Expanded(
          flex: 4,
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.topCenter,
            children: [
              EditScreen(
                child: buildTree(),
              ),
              const Positioned(
                top: 0,
                child: ToolBar(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Debug"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Refresh"),
                ),
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
                  data: WidgetData(
                    type: Column,
                    args: {
                      "crossAxisAlignment": CrossAxisAlignment.start,
                      "mainAxisAlignment": MainAxisAlignment.start,
                    },
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Column"),
                  ),
                ),
                DraggableContent<WidgetData>(
                  data: WidgetData(
                    type: Row,
                    args: {
                      "crossAxisAlignment": CrossAxisAlignment.start,
                      "mainAxisAlignment": MainAxisAlignment.start,
                    },
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("Row"),
                  ),
                ),
                DraggableContent<WidgetData>(
                  data: WidgetData(
                    type: TextField,
                    args: {},
                  ),
                  child: Container(
                    color: Colors.blueGrey,
                    child: const Text("TextField"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EditScreen extends StatefulWidget {
  final Widget child;

  const EditScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  double scale = 1;
  Offset offset = Offset(0, 0);
  Offset initialOffset = Offset(0, 0);
  Offset initialFocalPoint = Offset(0, 0);
  bool isScaling = false;

  void _handleScaleStart(ScaleStartDetails details) {
    if (isScaling) return;
    isScaling = true;
    initialOffset = offset;
    initialFocalPoint = details.focalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!isScaling) return;
    final double newScale = scale * details.scale;
    final double deltaScale = newScale - scale;
    final Offset normalizedOffset = (initialFocalPoint - initialOffset) / scale;

    final Offset newOffset = details.focalPoint - normalizedOffset * newScale;
    setState(() {
      scale = newScale;
      offset = newOffset;
    });
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    isScaling = false;
  }

  void _scaleUp() {
    setState(() {
      scale *= 1.1; // You can adjust the scaling factor
    });
  }

  void _scaleDown() {
    setState(() {
      scale /= 1.1; // You can adjust the scaling factor
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent && event.kind == PointerDeviceKind.mouse) {
          if (event.scrollDelta.dy > 0) {
            _scaleDown(); // Scroll down with Ctrl to zoom out
          } else if (event.scrollDelta.dy < 0) {
            _scaleUp(); // Scroll up with Ctrl to zoom in
          }
        }
      },
      child: Focus(
        autofocus: true,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(),
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          onScaleEnd: _handleScaleEnd,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: ClipRect(
              child: Transform.scale(
                scale: scale,
                child: Transform.translate(
                  offset: offset,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScaleUpIntent extends Intent {}

class ScaleDownIntent extends Intent {}
