import 'package:drag_n_drop/generated/assets.dart';
import 'package:drag_n_drop/providers/inspector_provider.dart';
import 'package:drag_n_drop/providers/theme_provider.dart';
import 'package:drag_n_drop/widgets/drag_items_view.dart';
import 'package:drag_n_drop/widgets/toolbar.dart';
import 'package:drag_n_drop/widgets/tree_view.dart';
import 'package:drag_n_drop/widgets/widget_inspector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'models/tree_node.dart';
import 'widgets/editor_screen.dart';

class DragNDrop extends StatefulWidget {
  const DragNDrop({super.key});

  @override
  State<DragNDrop> createState() => _DragNDropState();
}

class _DragNDropState extends State<DragNDrop> {
  double treeViewPer = 0.2;
  double dragItemsViewPer = 0.2;
  double editScreenPer = 0.6;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<InspectorProvider>().updateTree();
    });
  }

  Widget buildTree() {
    return context.read<InspectorProvider>().editScreenWidget;
  }

  @override
  Widget build(BuildContext context) {
    return ResizableContainer(
      direction: Axis.horizontal,
      children: [
        ResizableChildData(
          startingRatio: treeViewPer,
          child: Selector<InspectorProvider, TreeNode>(
            builder: (context, value, child) {
              return Column(
                children: [
                  const Expanded(child: TreeView()),
                  Expanded(
                    child: Column(
                      children: [
                        AppBar(
                          title: Text(
                            'Inspector',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          elevation: 0,
                          toolbarHeight: 30,
                        ),
                        const SizedBox(height: 8),
                        Selector<InspectorProvider, Widget?>(
                          builder: (context, selectedWidget, child) {
                            return SelectedWidgetInspector(
                              selectedWidget: selectedWidget,
                              onUpdate: (args) {
                                context.read<InspectorProvider>().updateWidget(args);
                              },
                            );
                          },
                          selector: (context, provider) => provider.selectedWidget?.widgetNode,
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
            selector: (context, provider) => provider.treeRoot,
          ),
        ),
        ResizableChildData(
          startingRatio: editScreenPer,
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.topCenter,
            children: [
              EditScreen(
                key: context.read<InspectorProvider>().editScreenKey,
                child: buildTree(),
              ),
              const Positioned(
                top: 0,
                child: ToolBar(),
              ),
              Positioned(
                top: 100,
                right: 0,
                child: Card(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () => context.read<InspectorProvider>().editScreenScaleUp(),
                        icon: const Icon(Icons.zoom_in),
                        splashRadius: 20,
                      ),
                      IconButton(
                        onPressed: () => context.read<InspectorProvider>().editScreenScaleDown(),
                        icon: const Icon(Icons.zoom_out),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 5,
                child: Consumer<ThemeProvider>(
                  builder: (BuildContext context, ThemeProvider provider, Widget? child) {
                    return ThemeButtonMenu(
                      onMaterialThemeUIChange: (state) {
                        provider.useMaterial = state;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ResizableChildData(
          startingRatio: dragItemsViewPer,
          child: const Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              DragItemsView(),
            ],
          ),
        ),
      ],
    );
  }
}

class ThemeButtonMenu extends StatefulWidget {
  final Function(bool state) onMaterialThemeUIChange;

  const ThemeButtonMenu({
    super.key,
    required this.onMaterialThemeUIChange,
  });

  @override
  State<ThemeButtonMenu> createState() => _ThemeButtonMenuState();
}

class _ThemeButtonMenuState extends State<ThemeButtonMenu> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = [context.read<ThemeProvider>().useMaterial];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(10),
              isSelected: isSelected,
              children: [
                SvgPicture.asset(
                  Assets.iconsMaterialUi,
                  width: 20,
                  height: 20,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ],
              onPressed: (index) {
                switch (index) {
                  case 0:
                    widget.onMaterialThemeUIChange(isSelected[index] = !isSelected[index]);
                    break;
                  default:
                    break;
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Consumer<ThemeProvider>(
          builder: (context, provider, child) => AdvancedSwitch(
            controller: () {
              final notifier = ValueNotifier<bool>(provider.isDarkMode);
              notifier.addListener(() {
                provider.toggleTheme();
              });
              return notifier;
            }.call(),
            activeColor: Colors.black54,
            inactiveColor: Colors.white54,
            thumb: ValueListenableBuilder(
              valueListenable: ValueNotifier<bool>(provider.isDarkMode),
              builder: (_, value, __) {
                if (value) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        Assets.iconsDark,
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SvgPicture.asset(Assets.iconsLight),
                  ),
                );
              },
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            width: 50.0,
            height: 30.0,
            enabled: true,
            disabledOpacity: 0.5,
          ),
        )
      ],
    );
  }
}
