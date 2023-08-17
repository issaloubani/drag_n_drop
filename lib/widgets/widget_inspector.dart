import 'package:drag_n_drop/models/enum_type.dart';
import 'package:drag_n_drop/models/registerer.dart';
import 'package:drag_n_drop/providers/inspector_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../generated/assets.dart';
import '../models/node.dart';

class SelectedWidgetInspector extends StatefulWidget {
  final Node? selectedWidget;
  final Node Function(Map<String, dynamic> args)? onUpdate;

  const SelectedWidgetInspector({super.key, this.selectedWidget, this.onUpdate});

  @override
  State<SelectedWidgetInspector> createState() => _SelectedWidgetInspectorState();
}

class _SelectedWidgetInspectorState extends State<SelectedWidgetInspector> {
  Node? peakNode;

  @override
  void initState() {
    super.initState();
  }

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
    peakNode = widget.selectedWidget?.copyWith();
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
                  child: Center(child: peakNode),
                ),
              ),
              const SizedBox(height: 16),
              if (widget.selectedWidget != null)
                Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: TableBorder.all(color: Colors.grey[300]!), children: [
                  ...widget.selectedWidget!.supportedParameters.entries.map(
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
                          child: _buildValueWidget(widget.selectedWidget!, argument.key),
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
    // build text field
    if (dataType == String) {
      return _buildTextField(node, key);
    }
    // build other data type
    if (dataType is EnumType) {
      return _buildDropdownList(node, key, dataType);
    }
    return Container();
  }

  void _onUpdate(Map<String, dynamic> args) {
    peakNode = widget.onUpdate?.call(args).copyWith();
    setState(() {});
  }

  DropdownButton<Object> _buildDropdownList(Node? node, String key, EnumType<dynamic> dataType) {
    return DropdownButton(
      value: node?.args[key],
      onChanged: (value) {
        node?.args[key] = value;
        _onUpdate(node?.args ?? {});
      },
      items: dataType.values
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString()),
              ))
          .toList(),
    );
  }

  TextField _buildTextField(Node? node, String key) {
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
          _onUpdate(node?.args ?? {});
        });
        return controller;
      }.call(),
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
