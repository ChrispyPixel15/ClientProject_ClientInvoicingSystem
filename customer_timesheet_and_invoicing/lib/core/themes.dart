import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primaryColor: Color.fromRGBO(43, 43, 43, 100),
  primaryColorDark: Color.fromRGBO(26, 26, 26, 100),
  primaryColorLight: Color.fromRGBO(74, 74, 74, 100),
  highlightColor: Color.fromRGBO(187, 187, 187, 1),
  hintColor: Color.fromRGBO(255, 0, 0, 1),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
    )
  )
);

final lightTheme = ThemeData(
  primaryColor: Color.fromRGBO(255, 255, 255, 1),
  primaryColorDark: Color.fromRGBO(207, 207, 207, 100),
  primaryColorLight: Color.fromRGBO(242, 242, 242, 100),
  highlightColor: Color.fromRGBO(78, 78, 78, 1),
  hintColor: Color.fromRGBO(255, 0, 0, 1),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: const Color.fromARGB(255, 0, 0, 0),
    ),
    bodySmall: TextStyle(
      color: const Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.w400,
    )
  )
);