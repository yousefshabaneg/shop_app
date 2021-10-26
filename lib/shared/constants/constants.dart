import 'package:flutter/material.dart';
import 'package:shop_app/data/cashe_helper.dart';
import 'package:shop_app/presentation/screens/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

String token = '';

void signOut(context) {
  CashHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(context, LoginScreen());
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
