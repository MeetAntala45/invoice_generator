import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Color.fromARGB(255, 99, 98, 98),
  hintColor: Color(0xFFC0C0C0),
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
      color: Color(0xFFC0C0C0),
    ),
    labelColor: Colors.white,
    unselectedLabelColor: Colors.black54,
  ),
  cardColor: Colors.white,
  cardTheme: CardTheme(
    shadowColor: Colors.grey.withOpacity(0.5),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color.fromARGB(255, 139, 139, 139),
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
    ),
    labelStyle: TextStyle(color: Colors.black54),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFC0C0C0),
    foregroundColor: Colors.white,
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
