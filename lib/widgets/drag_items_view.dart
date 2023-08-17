import 'package:collection/collection.dart';
import 'package:drag_n_drop/config/items.dart';
import 'package:drag_n_drop/widgets/drag_item.dart';
import 'package:flutter/material.dart';

class DragItemsView extends StatelessWidget {
  final int columnCount;

  const DragItemsView({super.key, this.columnCount = 2});

  @override
  Widget build(BuildContext context) {
    Iterable<List<DragItem>> items = supportedItems.slices(columnCount);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          children: items
              .map((e) => Row(
                    children: e.map((e) => Expanded(child: e)).toList(),
                  ))
              .toList(),
        ),
/*        child: Table(
          children: items.map(
            (slice) {
              if (slice.length < columnCount) {
                slice = slice.toList()..addAll(List.filled(columnCount - slice.length, null));
              }
              return TableRow(
                children: slice.map((e) => e).toList(),
              );
            },
          ).toList(),
        ),*/
      ),
    );
  }
}
