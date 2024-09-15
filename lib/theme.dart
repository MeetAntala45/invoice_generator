// theme.dart
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF2B2B2B), // Dark gray background
  primaryColor: Color(0xFF4CAF50), // Accent color (green)
  hintColor: Color(0xFF1E88E5), // Light blue accent
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
  ),
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      color: Colors.white, // Active tab indicator
    ),
    labelColor: Colors.white, // Active tab text
    unselectedLabelColor: Color(0xFFB0B0B0), // Inactive tab text
  ),
  cardColor: Color(0xFF333333), // Card background
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF4CAF50), // Install button background
    textTheme: ButtonTextTheme.primary,
  ),
);
