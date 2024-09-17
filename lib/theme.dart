// theme.dart
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color.fromARGB(255, 39, 39, 39), // Dark gray background
  primaryColor: Color(0xFF4CAF50), // Accent color (green)
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
  cardColor: Color.fromARGB(255, 75, 75, 75), // Card background
  buttonTheme: ButtonThemeData(
    buttonColor: Color.fromARGB(255, 42, 143, 138), // Install button background
    textTheme: ButtonTextTheme.primary,
  ),
);
