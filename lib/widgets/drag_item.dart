import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/widget_data.dart';
import 'draggable_content.dart';

class DragItem extends StatelessWidget {
  final WidgetData data;
  final String svgPath;
  final String name;

  const DragItem({super.key, required this.data, required this.svgPath, required this.name});

  @override
  Widget build(BuildContext context) {
    return DraggableContent<WidgetData>(
      data: data,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SvgPicture.asset(
                svgPath,
                width: 50,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              Text(
                name,
                style:  TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
