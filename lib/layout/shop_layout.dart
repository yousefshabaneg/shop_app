import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/presentation/screens/cart_screen.dart';
import 'package:shop_app/presentation/screens/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)
        ..getHomeData()
        ..getUserData()
        ..getCartData()
        ..getCategories()
        ..getFavorites()
        ..getAddresses()
        ..getOrders(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('OBAY'),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: buildIconWithNumber(
                      condition: ShopCubit.get(context).totalCarts != 0,
                      icon: Icons.shopping_cart_outlined,
                      number: ShopCubit.get(context).totalCarts,
                      radius: 10,
                      fontSize: 12,
                      alignment: Alignment(1, -0.8),
                      onPressed: () {
                        navigateTo(context, CartScreen());
                      }),
                ),
              ],
            ),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54, spreadRadius: 1, blurRadius: 3),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: BottomNavigationBar(
                  items: cubit.bottomItems,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) => cubit.changeBottomNav(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
