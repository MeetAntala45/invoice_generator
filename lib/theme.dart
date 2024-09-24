import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Color(0xFF0A74DA), // Professional blue color
  hintColor: Color(0xFF0A74DA),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: Colors.black, 
      fontSize: 24, 
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.black87, 
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Colors.black54, 
      fontSize: 14,
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      color: Color(0xFF0A74DA), // Matches primary color
    ),
    labelColor: Colors.white,
    unselectedLabelColor: Colors.black54,
  ),
  cardColor: Colors.white,
  cardTheme: CardTheme(
    shadowColor: Colors.grey.withOpacity(0.3),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF0A74DA), // Professional blue color for buttons
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0A74DA)),
    ),
    labelStyle: TextStyle(color: Colors.black54),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF0A74DA),
    foregroundColor: Colors.white,
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
