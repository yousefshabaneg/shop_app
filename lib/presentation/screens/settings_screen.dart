import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradients/gradients.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/presentation/screens/address_screen.dart';
import 'package:shop_app/presentation/screens/change_password_screen.dart';
import 'package:shop_app/presentation/screens/my_account_screen.dart';
import 'package:shop_app/presentation/screens/my_orders_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = ShopCubit.get(context).userModel;
        return Scaffold(
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) => Column(
              children: [
                Stack(
                  alignment: Alignment(0, -0.7),
                  children: [
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        gradient: LinearGradientPainter(
                          colors: [
                            Color(0xffBE3BFB),
                            Color(0xffC13BFC),
                            Color(0xff8E3FFF)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(userModel!.data!.image),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment(0.05, 0.4),
                        child: Text(
                          userModel.data!.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              letterSpacing: 1,
                              fontFamily: 'Cairo',
                              shadows: [
                                Shadow(
                                  offset: Offset(0.2, 0.2),
                                  blurRadius: 1.0,
                                  color: Color.fromARGB(255, 100, 100, 100),
                                )
                              ]),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment(0, 1.5),
                        child: Container(
                          width: 370,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 1,
                                ),
                              ]),
                          child: buildRowIcons(context),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    buildColumnAction(Icons.account_circle, "My Account",
                        onTap: () {
                      navigateTo(context, MyAccountScreen());
                    }),
                    buildColumnAction(Icons.vpn_key, "Change Password",
                        onTap: () {
                      navigateTo(context, ChangePasswordScreen());
                    }),
                    buildColumnAction(
                      Icons.add_location_rounded,
                      "Change Address",
                      onTap: () {
                        navigateTo(context, AddressScreen());
                      },
                    ),
                  ],
                )
              ],
            ),
            fallback: (context) => buildProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildRowIcons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            buildIconWithNumber(
                condition:
                    ShopCubit.get(context).orderModel!.data.data.length != 0,
                icon: Icons.list_alt_outlined,
                iconColor: Colors.black.withOpacity(0.6),
                number: ShopCubit.get(context).orderModel!.data.data.length,
                onPressed: () {
                  navigateTo(context, MyOrdersScreen());
                }),
            iconText('My Orders'),
          ],
        ),
        Column(
          children: [
            buildIconWithNumber(
                condition: ShopCubit.get(context).itemsInFavorites != 0,
                icon: Icons.favorite_border_outlined,
                iconColor: Colors.black.withOpacity(0.6),
                number: ShopCubit.get(context).itemsInFavorites,
                onPressed: () {
                  ShopCubit.get(context).changeBottomNav(2);
                }),
            iconText('Wishlist'),
          ],
        ),
        Column(
          children: [
            buildIconWithNumber(
              condition: true,
              alignment: Alignment(1.6, -0.8),
              icon: Icons.notifications_outlined,
              iconColor: Colors.black.withOpacity(0.6),
              number: 3,
              size: 35,
            ),
            iconText('Notifications'),
          ],
        ),
      ],
    );
  }

  Widget buildColumnAction(icon, text, {onTap}) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 350,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFEDF2FB),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: MyColors.info,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      );
}
