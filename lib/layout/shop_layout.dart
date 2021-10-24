import 'package:flutter/material.dart';
import 'package:shop_app/data/cashe_helper.dart';
import 'package:shop_app/presentation/screens/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OBAY'),
        actions: [
          TextButton(
            onPressed: () {
              CashHelper.removeData(key: 'token');
              navigateAndFinish(context, LoginScreen());
            },
            child: Text('Sign Out'),
          )
        ],
      ),
    );
  }
}
