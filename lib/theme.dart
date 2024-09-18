import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color.fromARGB(255, 39, 39, 39),
  primaryColor: Color(0xFF4CAF50), 
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
  ),
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      color: Colors.white,
    ),
    labelColor: Colors.white,
    unselectedLabelColor: Color(0xFFB0B0B0),
  ),
  cardColor: Color.fromARGB(255, 75, 75, 75),
  buttonTheme: ButtonThemeData(
    buttonColor: Color.fromARGB(255, 42, 143, 138),
    textTheme: ButtonTextTheme.primary,
  ),
);
