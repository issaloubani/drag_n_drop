import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/inspector_provider.dart';
import 'drag_n_drop.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InspectorProvider()),
      ],
      child: MaterialApp(
        title: 'Drag n drop',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const Main(),
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: DragNDrop()),
          Container(),
        ],
      ),
    );
  }
}
