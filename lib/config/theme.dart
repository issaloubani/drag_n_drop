import 'package:drag_n_drop/models/drag_n_drop_theme.dart';
import 'package:flutter/material.dart';

Map<String, DragNDropTheme> supportedThemes = {
  "light": DragNDropTheme(
    theme: ThemeData.light().copyWith(
      useMaterial3: false,
    ),
  ),
  "dark": DragNDropTheme(
    theme: ThemeData.dark().copyWith(
      useMaterial3: false,
    ),
  ),
};
