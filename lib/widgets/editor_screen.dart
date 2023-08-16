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
  Size size = const Size(1024, 768);
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

  _EditScreenState() {
    // Initialize the offset to center the edited UI within the EditScreen
    final initialX = (size.width - size.width * scale) / 2;
    final initialY = (size.height - size.height * scale) / 2;
    offset = Offset(initialX, initialY);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      child: Listener(
        onPointerSignal: (PointerSignalEvent event) {
          if (event is PointerScrollEvent && event.kind == PointerDeviceKind.mouse) {
            if (event.scrollDelta.dy > 0) {
              _scaleDown();
            } else if (event.scrollDelta.dy < 0) {
              _scaleUp();
            }
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust the edited UI position to keep it centered
            final editedUIPosition = Offset(
              (constraints.maxWidth - size.width) / 2,
              (constraints.maxHeight - size.height) / 2,
            );

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: ClipRRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background content
                    Container(),
                    // Edited UI
                    Positioned(
                      top: editedUIPosition.dy,
                      left: editedUIPosition.dx,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..translate(offset.dx, offset.dy)
                          ..scale(scale),
                        child: SizedBox.fromSize(
                          size: size,
                          child: widget.child,
                        ),
                      ),
                    ),
                    // zoom in/out
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: _scaleUp,
                            icon: const Icon(Icons.zoom_in),
                          ),
                          IconButton(
                            onPressed: _scaleDown,
                            icon: const Icon(Icons.zoom_out),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
