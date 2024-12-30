import 'package:flutter/material.dart';

class AppTheme {
  // VS Code inspired colors
  static const Color vsBlue = Color(0xFF007ACC);      // VS Code's signature blue
  static const Color vsLightBlue = Color(0xFF0098FF); // Lighter accent blue
  static const Color pureBlack = Color(0xFF000000);   // Pure black for nav bar
  static const Color primaryBlack = Color(0xFF1E1E1E); // VS Code background
  static const Color secondaryBlack = Color(0xFF252526);
  static const Color surfaceBlack = Color(0xFF2D2D2D);
  static const Color vsGrey = Color(0xFF3C3C3C);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryBlack,
    
    // Color Scheme
    colorScheme: const ColorScheme.dark(
      background: primaryBlack,
      surface: surfaceBlack,
      primary: vsBlue,
      secondary: vsLightBlue,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    
    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: pureBlack,
      indicatorColor: vsBlue.withOpacity(0.15),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: vsBlue, size: 24);
        }
        return const IconThemeData(color: Colors.white, size: 24);
      }),
    ),
  );
}