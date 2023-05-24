import 'package:flutter/material.dart';

final theme = ThemeData.from(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF00C864),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF0064C8),
    onSecondary: Color(0xFF000000),
    error: Color(0xFFBB0000),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFF121212),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFFFFF),
  ),
);

const gradient = LinearGradient(
  begin: FractionalOffset.topLeft,
  end: FractionalOffset.bottomRight,
  colors: [
    Color(0xFF00C864),
    Color(0xFF0064C8),
  ],
);
