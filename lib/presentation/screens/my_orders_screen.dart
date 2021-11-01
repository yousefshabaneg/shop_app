import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/business_logic/login_cubit/login_cubit.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/order_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).orderModel!.data.data.length > 0,
            builder: (context) => ConditionalBuilder(
              condition: ShopCubit.get(context).ordersDetails.isNotEmpty,
              builder: (context) => SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Text(
                            'My Orders  ',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              color: MyColors.light,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 3.0),
                            child: Text(
                              '( ${ShopCubit.get(context).orderModel!.data.data.length.toString()} orders )',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Spacer(),
                          if (state is ShopChangeFavoritesState)
                            buildProgressIndicator(),
                        ],
                      ),
                    ),
                    ListView.separated(
                      itemBuilder: (context, index) => buildOrderItem(
                          ShopCubit.get(context).ordersDetails[index].data,
                          context,
                          state),
                      separatorBuilder: (context, index) => Container(),
                      itemCount: ShopCubit.get(context).ordersDetails.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ),
              fallback: (context) => buildProgressIndicator(),
            ),
            fallback: (context) => buildNoOrders(context),
          ),
        );
      },
    );
  }

  Widget buildOrderItem(OrderDetailsData model, context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order ID: ${model.id}",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      model.date,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                        fontFamily: "Cairo",
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Cost : ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.cost)} LE",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                            color: MyColors.light,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "VAT : ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.vat)} LE",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                            color: MyColors.light,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Total Amount : ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.total)} LE",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo",
                        color: MyColors.light,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.status,
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    defaultButton(
                      text: "Cancel",
                      fontSize: 12,
                      radius: 20,
                      background: MyColors.primary,
                      onPressed: () {},
                      width: 100,
                      height: 35,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildNoOrders(context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.list_alt_outlined,
                size: 60,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'There are no orders associated with your account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MyColors.primary,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            defaultButton(
              text: 'Start Shopping Now',
              onPressed: () {
                ShopCubit.get(context).changeBottomNav(0);
              },
              fontSize: 18,
              width: 250,
              radius: 20,
              background: MyColors.primary,
            )
          ],
        ),
      );
}
