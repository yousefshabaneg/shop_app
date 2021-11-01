import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

ThemeData lightTheme = ThemeData(
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: MyColors.secondary,
    ),
  ),
  primarySwatch: MyColors.primaryColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 25,
    ),
    backgroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      color: MyColors.primary,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: MyColors.primary,
    unselectedItemColor: MyColors.dark,
    elevation: 20,
    backgroundColor: Colors.white,
    selectedLabelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  ),
  fontFamily: 'Janna',
);

ThemeData darkTheme = ThemeData(
  textTheme: TextTheme(
      button: TextStyle(
        color: MyColors.light,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        color: MyColors.light,
      )),
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: MyColors.light,
        secondary: MyColors.green,
      ),
  primarySwatch: MyColors.primaryColor,
  scaffoldBackgroundColor: MyColors.secondary,
  appBarTheme: AppBarTheme(
    color: MyColors.primary,
    iconTheme: IconThemeData(
      color: MyColors.secondary,
      size: 25,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: MyColors.primary,
      statusBarIconBrightness: Brightness.dark,
    ),
    elevation: 3,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      color: MyColors.secondary,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: MyColors.primary,
    unselectedItemColor: MyColors.dark,
    elevation: 20,
    backgroundColor: Colors.white,
    selectedLabelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  ),
  fontFamily: 'Janna',
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: MyColors.light.withOpacity(0.6),
    ),
    errorStyle: TextStyle(
      color: MyColors.red,
      fontSize: 12,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.red),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: MyColors.grey,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: MyColors.grey,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    prefixStyle: TextStyle(
      color: MyColors.primary,
    ),
    suffixStyle: TextStyle(
      color: MyColors.primary,
    ),
    filled: true,
    fillColor: MyColors.card,
  ),
);
