import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/cubit/cubit_observer.dart';
import 'package:shop_app/business_logic/login_cubit/login_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/data/api/dio_helper.dart';
import 'package:shop_app/data/cashe_helper.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/presentation/screens/login_screen.dart';
import 'package:shop_app/presentation/screens/on_boarding_screen.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/styles/themes.dart';

Widget chooseWidget({required bool onBoarding, String? token}) {
  if (onBoarding) {
    return token != null ? ShopLayout() : LoginScreen();
  }
  return OnBoardingScreen();
}

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CashHelper.init();
  bool onBoarding = CashHelper.getData(key: 'onBoarding') ?? false;
  token = CashHelper.getData(key: 'token');
  print(token);
  Widget widget = chooseWidget(onBoarding: onBoarding, token: token);

  runApp(MyApp(onBoarding, widget));
}

class MyApp extends StatelessWidget {
  final bool onBoarding;
  final Widget widget;
  MyApp(this.onBoarding, this.widget);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getOrders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: widget,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}
