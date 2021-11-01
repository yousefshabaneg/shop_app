import 'package:flutter/material.dart';

class MyColors {
  static var primary = Color(0xFFFFC100);
  static var secondary = Color(0xFF182140);
  static var card = Color(0xFF181725);
  static var grey = Color(0xFF30475E);
  static var yellow = Color(0xFFFEC260);
  static var green = Color(0xFF27C499);
  static var red = Color(0xFFF05454);
  static var dark = Color(0xFF222831);
  static var light = Color(0xffDDDDDD);

  static Map<int, Color> swatch = {
    50: const Color(0x1AFFC100), //10%
    100: const Color(0x33FFC100), //20%
    200: const Color(0x4DFFC100), //30%
    300: const Color(0x66FFC100), //40%
    400: const Color(0x80FFC100), //50%
    500: const Color(0x99FFC100), //60%
    600: const Color(0xBFFFC100), //70%
    700: const Color(0xCCFFC100), //80%
    800: const Color(0xE6FFC100), //90%
    900: const Color(0xffFFC100), //100%
  };

  static MaterialColor primaryColor = MaterialColor(0xffFFC100, swatch);
}

// class MyColors {
//   static var primary = Color(0xff38B6FF);
//   static var secondary = Color(0xFF253c78);
//   static var info = Color(0xFF8C52FF);
//   static var orange = Color(0xFFFF914D);
//   static var yellow = Color(0xFFFFDE59);
//   static var green = Color(0xFFC9E265);
//   static var white = Color(0xffF2F2F2);
//   static var black = Color(0xff010203);
//   static var dark = Color(0xFF8D8E98);
//   static var darkness = Color(0xFF8D8E98).withOpacity(0.8);
//
//   static Map<int, Color> swatch = {
//     50: const Color(0x1Aff38B6FF), //10%
//     100: const Color(0x33ff38B6FF), //20%
//     200: const Color(0x4Dff38B6FF), //30%
//     300: const Color(0x66ff38B6FF), //40%
//     400: const Color(0x80ff38B6FF), //50%
//     500: const Color(0x99ff38B6FF), //60%
//     600: const Color(0xBFff38B6FF), //70%
//     700: const Color(0xCCff38B6FF), //80%
//     800: const Color(0xE6ff38B6FF), //90%
//     900: const Color(0xffff38B6FF), //100%
//   };
//
//   static MaterialColor primaryColor = MaterialColor(0xff38B6FF, swatch);
// }
