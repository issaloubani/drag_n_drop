import 'package:drag_n_drop/nodes/center_node.dart';
import 'package:drag_n_drop/nodes/column_node.dart';
import 'package:drag_n_drop/nodes/row_node.dart';
import 'package:flutter/material.dart';

import '../models/node.dart';
import '../nodes/appbar_node.dart';
import '../nodes/container_node.dart';
import '../nodes/padding_node.dart';
import '../nodes/scaffold_node.dart';
import '../nodes/text_node.dart';

final Map<Type, Node> supportedItems = {
  AppBar: AppBarNode(),
  Center: CenterNode(),
  Column: ColumnNode(),
  Container: ContainerNode(),
  Row: RowNode(),
  Padding: PaddingNode(),
  Text: TextNode(),
  Scaffold: ScaffoldNode(),
};
