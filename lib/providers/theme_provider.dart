import 'package:drag_n_drop/config/theme.dart';
import 'package:flutter/cupertino.dart';

import '../models/drag_n_drop_theme.dart';

class ThemeProvider extends ChangeNotifier {
  DragNDropTheme _dragNDropTheme = supportedThemes.isNotEmpty
      ? supportedThemes.values.first
      : DragNDropTheme(
          theme: null,
        );

  DragNDropTheme get selectedTheme => _dragNDropTheme;

  void setTheme(DragNDropTheme theme) {
    _dragNDropTheme = theme;
  }

  bool get useMaterial => _dragNDropTheme.theme?.useMaterial3 ?? false;

  set theme(DragNDropTheme theme) {
    _dragNDropTheme = theme;
    notifyListeners();
  }

  set useMaterial(bool value) {
    if (_dragNDropTheme.theme != null) {
      _dragNDropTheme.theme = _dragNDropTheme.theme!.copyWith(
        useMaterial3: value,
      );
    }
    notifyListeners();
  }
}
