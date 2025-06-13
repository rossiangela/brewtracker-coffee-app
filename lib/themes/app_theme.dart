import 'package:flutter/material.dart';

class AppTheme {
  static const Color coffeeBean = Color(0xFF3E2723);
  static const Color espresso = Color(0xFF5D4037);
  static const Color milkFoam = Color(0xFFF5F5DC);
  static const Color caramel = Color(0xFFD2691E);
  static const Color darkRoast = Color(0xFF1B1B1B);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: espresso,
      brightness: Brightness.light,
    ).copyWith(
      primary: espresso,
      secondary: caramel,
      surface: milkFoam,
      background: const Color(0xFFFFFBF5),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFBF5),
      foregroundColor: coffeeBean,
      elevation: 0,
      centerTitle: true,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: espresso,
      brightness: Brightness.dark,
    ).copyWith(
      primary: caramel,
      secondary: espresso,
      surface: darkRoast,
      background: const Color(0xFF121212),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkRoast,
      foregroundColor: milkFoam,
      elevation: 0,
      centerTitle: true,
    ),
  );
}


