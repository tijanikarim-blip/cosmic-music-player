import 'package:flutter/material.dart';
import 'music_theme.dart';

class ThemeProvider extends ChangeNotifier {
  MusicThemeType _currentTheme;

  ThemeProvider({MusicThemeType initialTheme = MusicThemeType.galaxyStorm})
      : _currentTheme = initialTheme;

  MusicThemeType get currentTheme => _currentTheme;

  void setTheme(MusicThemeType theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  Color getPrimaryColor() => MusicTheme.getPrimaryColor(_currentTheme);
  Color getTextColor() => MusicTheme.getTextColor(_currentTheme);
  Color getSecondaryColor() => MusicTheme.getSecondaryColor(_currentTheme);
}
