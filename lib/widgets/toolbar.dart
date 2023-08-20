import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inspector_provider.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ads_click),
            splashRadius: 20,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.back_hand),
            splashRadius: 20,
          ),
          IconButton(
            onPressed: () {
              context.read<InspectorProvider>().setMode(InspectorMode.preview);
            },
            icon: const Icon(Icons.remove_red_eye_rounded),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
