import 'package:flutter/material.dart';
import 'package:shop_app/data/api/api.dart';
import 'package:shop_app/presentation/screens/on_boarding_screen.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'data/cashe_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CashHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: OnBoardingScreen(),
    );
  }
}
