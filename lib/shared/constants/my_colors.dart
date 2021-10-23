import 'package:flutter/material.dart';

class MyColors {
  static var primary = Color(0xff2E5CB5);
  static var secondary = Color(0xFF253c78);
  static var info = Color(0xFFB0D5E6);
  static var white = Color(0xffF2F2F2);
  static var black = Color(0xff010203);
  static var dark = Color(0xFF8D8E98);
  static var darkness = Color(0xFF8D8E98).withOpacity(0.8);

  static Map<int, Color> swatch = {
    50: const Color(0x1A2E5CB5), //10%
    100: const Color(0x332E5CB5), //20%
    200: const Color(0x4D2E5CB5), //30%
    300: const Color(0x662E5CB5), //40%
    400: const Color(0x802E5CB5), //50%
    500: const Color(0x992E5CB5), //60%
    600: const Color(0xBF2E5CB5), //70%
    700: const Color(0xCC2E5CB5), //80%
    800: const Color(0xE62E5CB5), //90%
    900: const Color(0xff2E5CB5), //100%
  };

  static MaterialColor primaryColor = MaterialColor(0xff2E5CB5, swatch);
}
