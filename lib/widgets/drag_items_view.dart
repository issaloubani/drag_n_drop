import 'package:collection/collection.dart';
import 'package:drag_n_drop/config/items.dart';
import 'package:drag_n_drop/widgets/drag_item.dart';
import 'package:flutter/material.dart';

class DragItemsView extends StatelessWidget {
  const DragItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    Iterable<List<DragItem>> items = supportedItems.slices(2);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Table(
          children: items
              .map(
                (e) => TableRow(
                  children: e.map((e) => e).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
