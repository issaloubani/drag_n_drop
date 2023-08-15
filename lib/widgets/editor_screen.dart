import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final Widget child;

  const EditScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  double scale = .8;
  Offset offset = const Offset(0, 0);
  Offset initialOffset = const Offset(0, 0);
  Offset initialFocalPoint = const Offset(0, 0);
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
            _scaleDown();
          } else if (event.scrollDelta.dy < 0) {
            _scaleUp();
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
              color: Colors.grey[300],
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
