import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
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
        var user = ShopCubit.get(context).userModel!.data!;
        return Scaffold(
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) => Container(
              color: MyColors.secondary,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      ClipPath(
                        clipper: OvalBottomBorderClipper(),
                        child: Container(
                          height: 230,
                          color: MyColors.primary,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment(-0.9, -0.90),
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              color: MyColors.card,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MyColors.light,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: AssetImage('assets/images/1.jpg'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 270,
                                    child: Text(
                                      "Hi, ${user.name.toUpperCase()}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: MyColors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "UID: ${user.id}",
                                    style: TextStyle(
                                      color: MyColors.grey.withOpacity(0.9),
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "Email Address: ${user.email.toUpperCase()}",
                                    style: TextStyle(
                                      color: MyColors.grey.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment(0, 1.9),
                      child: Container(
                        height: 480,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyColors.card,
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                navigateTo(context, MyOrdersScreen());
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 15, 5, 19),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.view_list,
                                      size: 25,
                                      color: MyColors.red,
                                    ),
                                    SizedBox(
                                      width: 35,
                                    ),
                                    Text(
                                      "My Orders",
                                      style: TextStyle(
                                          color: MyColors.light,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Total (${ShopCubit.get(context).ordersDetails.length})",
                                      style: TextStyle(
                                        color: MyColors.primaryColor
                                            .withOpacity(0.6),
                                        fontFamily: "Roboto",
                                        fontSize: 13,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      size: 30,
                                      color: MyColors.grey.withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                ShopCubit.get(context).changeBottomNav(2);
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 15, 5, 19),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      size: 25,
                                      color: MyColors.red,
                                    ),
                                    SizedBox(
                                      width: 35,
                                    ),
                                    Text(
                                      "My Wishlist",
                                      style: TextStyle(
                                          color: MyColors.light,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Total (${ShopCubit.get(context).favoritesModel!.data.favData.length})",
                                      style: TextStyle(
                                        color: MyColors.primaryColor
                                            .withOpacity(0.6),
                                        fontFamily: "Roboto",
                                        fontSize: 13,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      size: 30,
                                      color: MyColors.grey.withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            buildRowIcons(
                                onTap: () {
                                  navigateTo(context, AddressScreen());
                                },
                                text: "My Address",
                                icon: Icons.location_on,
                                color: Colors.orange),
                            buildRowIcons(
                              text: "My Profile",
                              icon: Icons.account_box,
                            ),
                            buildRowIcons(
                                text: "Change Password",
                                icon: Icons.vpn_key,
                                color: Colors.indigo),
                            buildRowIcons(
                              text: "About us",
                              icon: Icons.info,
                            ),
                            buildRowIcons(
                              text: "Sign Out",
                              icon: Icons.logout,
                              onTap: () {
                                signOut(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            fallback: (context) => buildProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildRowIcons({text, icon, color, onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 5, 19),
        child: Row(
          children: [
            Icon(
              icon,
              size: 25,
              color: MyColors.red,
            ),
            SizedBox(
              width: 35,
            ),
            Text(
              text,
              style: TextStyle(
                  color: MyColors.light,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Spacer(),
            Icon(
              Icons.arrow_right,
              size: 30,
              color: MyColors.grey.withOpacity(0.6),
            ),
          ],
        ),
      ),
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
                color: MyColors.light,
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
