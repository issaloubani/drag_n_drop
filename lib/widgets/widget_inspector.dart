import 'package:drag_n_drop/widgets/target_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../models/node.dart';

class SelectedWidgetInspector extends StatefulWidget {
  final Widget? selectedWidget;

  const SelectedWidgetInspector({super.key, this.selectedWidget});

  @override
  State<SelectedWidgetInspector> createState() => _SelectedWidgetInspectorState();
}

class _SelectedWidgetInspectorState extends State<SelectedWidgetInspector> {
  Widget get idleWidget => Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: SvgPicture.asset(
                Assets.iconsEmpty,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Select a widget to inspect',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ],
        ),
      );

  Widget get errorWidget => Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: SvgPicture.asset(
                Assets.iconsError,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Unable to inspect this widget',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (widget.selectedWidget == null) {
      return idleWidget;
    }
    Node? node;
    if (widget.selectedWidget is Node) {
      node = widget.selectedWidget as Node;
    } else if (widget.selectedWidget is TargetNode) {
      node = (widget.selectedWidget as TargetNode).node;
    } else {
      return errorWidget;
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.grey[200],
                child: SizedBox.fromSize(
                  size: const Size.fromHeight(100),
                  child: Center(child: widget.selectedWidget!),
                ),
              ),
              const SizedBox(height: 16),
              Table(border: TableBorder.all(color: Colors.grey[300]!), children: [
                ...node!.args.entries.map(
                  (e) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.key,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.value.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
