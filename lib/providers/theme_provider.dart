import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ThemeProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(this._prefs) {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadThemeMode() {
    final themeModeIndex = _prefs.getInt('theme_mode') ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _prefs.setInt('theme_mode', themeMode.index);
    notifyListeners();
  }
}