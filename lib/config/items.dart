import 'package:drag_n_drop/generated/assets.dart';
import 'package:drag_n_drop/models/widget_data.dart';
import 'package:flutter/material.dart';

import '../widgets/drag_item.dart';

List<DragItem> supportedItems = [
  DragItem(
    data: WidgetData(
      type: Container,
      args: {},
    ),
    svgPath: Assets.iconsContainer,
    name: "Container",
  ),
  DragItem(
    data: WidgetData(
      type: Text,
      isTarget: false,
      args: {
        "text": "Label",
      },
    ),
    svgPath: Assets.iconsText,
    name: "Text",
  ),
  DragItem(
    data: WidgetData(
      type: Column,
      args: {},
    ),
    svgPath: Assets.iconsColumn,
    name: "Column",
  ),
  DragItem(
    data: WidgetData(
      type: Row,
      args: {},
    ),
    svgPath: Assets.iconsRow,
    name: "Row",
  ),
  DragItem(
    data: WidgetData(
      type: Center,
      args: {},
    ),
    svgPath: Assets.iconsCenter,
    name: "Center",
  ),
  DragItem(
    data: WidgetData(
      type: Padding,
      args: {
        "padding": const EdgeInsets.all(8.0),
      },
    ),
    svgPath: Assets.iconsPadding,
    name: "Padding",
  ),
];
