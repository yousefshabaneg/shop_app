import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/data/cashe_helper.dart';
import 'package:shop_app/presentation/screens/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';

String? token = '';

void signOut(context) async {
  await CashHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(context, LoginScreen());
      ShopCubit.get(context).productsQuantity.clear();
      ShopCubit.get(context).totalCarts = 0;
      ShopCubit.get(context).currentIndex = 0;
    }
  });
}
