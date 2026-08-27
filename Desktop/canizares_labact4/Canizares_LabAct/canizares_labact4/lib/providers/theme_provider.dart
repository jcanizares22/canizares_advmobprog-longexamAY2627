import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _darkModeKey = 'dark_mode';
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadPreference();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadPreference() async {
    final preferences = await SharedPreferences.getInstance();
    _isDarkMode = preferences.getBool(_darkModeKey) ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_darkModeKey, value);
  }
}
