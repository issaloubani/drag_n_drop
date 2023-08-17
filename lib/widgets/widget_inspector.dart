import 'package:drag_n_drop/models/enum_type.dart';
import 'package:drag_n_drop/widgets/target_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../models/node.dart';

class SelectedWidgetInspector extends StatefulWidget {
  final Widget? selectedWidget;
  final void Function(Map<String, dynamic> args)? onUpdate;

  const SelectedWidgetInspector({super.key, this.selectedWidget, this.onUpdate});

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
              /*Card(
                color: Colors.grey[200],
                child: SizedBox.fromSize(
                  size: const Size.fromHeight(100),
                  child: Center(child: widget.selectedWidget!),
                ),
              ),
              const SizedBox(height: 16),*/
              Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: TableBorder.all(color: Colors.grey[300]!), children: [
                ...node!.supportedParameters.entries.map(
                      (argument) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          argument.key,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildValueWidget(node, argument.key),
                        // child: Text(
                        //   e.value.toString(),
                        //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        //         color: Colors.grey[600],
                        //       ),
                        // ),
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

  Widget _buildValueWidget(Node? node, String key) {
    final dataType = node?.supportedParameters[key] ?? Null;

    print("dataType is enum: ${dataType is EnumType}");
    print("dataType $dataType");
    if (dataType == String) {
      return TextField(
        controller: () {
          final controller = TextEditingController();
          controller.value = controller.value.copyWith(
              text: node?.args[key].toString(),
              selection: TextSelection.fromPosition(
                TextPosition(offset: node?.args[key].toString().length ?? 0),
              ));
          controller.addListener(() {
            node?.args[key] = controller.text;
            widget.onUpdate?.call(node?.args ?? {});
          });
          return controller;
        }.call(),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      );
    }
    // build other data type
    if(dataType is EnumType) {
      return DropdownButton(
        value: node?.args[key],
        onChanged: (value) {
          node?.args[key] = value;
          widget.onUpdate?.call(node?.args ?? {});
        },
        items: dataType.values.map((e) => DropdownMenuItem(
          value: e,
          child: Text(e.toString()),
        )).toList(),
      );
    }
    return Container();
  }
}
