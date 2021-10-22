import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

ThemeData lightTheme = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: new BorderSide(color: MyColors.primary),
    ),
    hintStyle: TextStyle(
      color: MyColors.dark,
      fontWeight: FontWeight.w500,
    ),
  ),
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
  iconTheme: IconThemeData(
    color: MyColors.secondary,
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
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: new BorderSide(
        color: MyColors.primary,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.white.withOpacity(0.7),
    ),
  ),
  scaffoldBackgroundColor: MyColors.secondary,
  primarySwatch: MyColors.primaryColor,
  appBarTheme: AppBarTheme(
    backgroundColor: MyColors.secondary,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: MyColors.secondary,
      statusBarIconBrightness: Brightness.light,
    ),
    elevation: 0,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: MyColors.primary,
      fontSize: 20,
    ),
    iconTheme: IconThemeData(
      color: Colors.white.withOpacity(0.7),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: MyColors.primary,
    unselectedItemColor: Colors.white.withOpacity(0.6),
    elevation: 20,
    backgroundColor: MyColors.secondary,
    selectedLabelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white.withOpacity(0.9),
    ),
  ),
  fontFamily: 'Janna',
);
