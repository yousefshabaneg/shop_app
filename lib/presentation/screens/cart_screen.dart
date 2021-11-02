import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/get_carts_model.dart';
import 'package:shop_app/presentation/screens/address_screen.dart';
import 'package:shop_app/presentation/screens/my_orders_screen.dart';
import 'package:shop_app/presentation/screens/product_details_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeCartItemState)
          showToast(
              msg: state.model.message, state: ToastStates.SUCCESS, seconds: 2);
        if (state is ShopSuccessChangeFavoritesState)
          showToast(
              msg: state.model.message, state: ToastStates.SUCCESS, seconds: 2);
        if (state is ShopSuccessUpdateQuantityItemState)
          showToast(
              msg: state.model.message, state: ToastStates.SUCCESS, seconds: 2);
        if (state is AddOrderSuccessState) {
          if (state.addOrderModel.status) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.SCALE,
              title: 'Your Order in progress',
              desc:
                  "Your order was placed successfully.\n For more details check Delivery Status in settings.",
              btnOkText: "Orders",
              btnOkOnPress: () {
                Navigator.pop(context);
                ShopCubit.get(context).changeBottomNav(3);
                navigateTo(context, MyOrdersScreen());
              },
              btnCancelOnPress: () {
                Navigator.pop(context);
              },
              btnCancelText: "Home",
              btnCancelColor: MyColors.primary,
              btnOkIcon: Icons.list_alt_outlined,
              btnCancelIcon: Icons.home,
              width: 400,
            )..show();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              children: [
                Text(
                  'Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: MyColors.secondary,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                if (state is ShopChangeCartItemState) buildProgressIndicator(),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: MyColors.card,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Text(
                          '${ShopCubit.get(context).totalCarts}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: MyColors.light,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Items',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: MyColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).totalCarts > 0,
            builder: (context) => Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          itemBuilder: (context, index) => buildInCartProduct(
                              ShopCubit.get(context)
                                  .cartModel!
                                  .data
                                  .cartItems[index],
                              ShopCubit.get(context).cartModel!.data.total,
                              context,
                              state),
                          itemCount: ShopCubit.get(context)
                              .cartModel!
                              .data
                              .cartItems
                              .length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                if (ShopCubit.get(context).totalCarts > 0)
                  Align(
                    alignment: Alignment(0, 1),
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      child: ConditionalBuilder(
                        condition: ShopCubit.get(context).addressId != 0,
                        builder: (context) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: state is! AddOrderLoadingState
                              ? primaryButton(
                                  text:
                                      "Checkout ( ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(ShopCubit.get(context).cartModel!.data.total)} LE )",
                                  onPressed: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.QUESTION,
                                      animType: AnimType.SCALE,
                                      title:
                                          'Are you Sure for Confirm this Order ?',
                                      btnOkOnPress: () {
                                        ShopCubit.get(context).addNewOrder();
                                      },
                                      btnCancelText: "Cancel",
                                      btnCancelOnPress: () {},
                                    )..show();
                                  },
                                )
                              : buildProgressIndicator(),
                        ),
                        fallback: (context) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: primaryButton(
                            text: 'Add your address to continue checkout.',
                            onPressed: () {
                              navigateTo(context, AddressScreen());
                            },
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            fallback: (context) => buildNoCartItems(context),
          ),
        );
      },
    );
  }

  Widget buildInCartProduct(CartItem model, total, context, state) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            ProductDetailsScreen(
                productModel: ShopCubit.get(context).homeModel!.data.products[
                    ShopCubit.get(context).productsMap[model.product.id]]));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: MyColors.card,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                      width: 130,
                      height: 130,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image(
                        image: NetworkImage(
                          model.product.image,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            color: MyColors.light,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (model.product.discount != 0)
                          Row(
                            children: [
                              Text(
                                'Save ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.product.oldPrice - model.product.price)} (${model.product.discount}%)',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  NumberFormat.currency(
                                          decimalDigits: 0, symbol: "")
                                      .format(model.product.price),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Text(
                                  ' LE',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.light,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            if (model.product.discount > 0)
                              Text(
                                '${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.product.oldPrice)} LE',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: MyColors.light.withOpacity(0.6),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              divider(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ShopCubit.get(context)
                              .changeQuantityItem(model.product.id);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: MyColors.green,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: MyColors.primary,
                                  blurRadius: 1,
                                  offset: Offset(1, 1),
                                )
                              ]),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${ShopCubit.get(context).productsQuantity[model.product.id] != null ? ShopCubit.get(context).productsQuantity[model.product.id] : model.quantity}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primary,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (ShopCubit.get(context)
                                  .productsQuantity[model.product.id] >
                              1) {
                            ShopCubit.get(context).changeQuantityItem(
                              model.product.id,
                              increment: false,
                            );
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: ShopCubit.get(context).productsQuantity[
                                              model.product.id] ==
                                          1 ||
                                      ShopCubit.get(context).productsQuantity[
                                              model.product.id] ==
                                          null
                                  ? MyColors.card
                                  : MyColors.green,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: MyColors.primary,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                )
                              ]),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(model.product.id);
                    },
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor: MyColors.primary,
                      child: Icon(
                        ShopCubit.get(context).favorites[model.product.id]!
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        size: 18,
                        color: MyColors.dark,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeCartItem(model.product.id);
                    },
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNoCartItems(context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: MyColors.primaryColor,
              radius: 50,
              child: Icon(
                Icons.shopping_cart_sharp,
                color: MyColors.secondary,
                size: 60,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your cart is empty!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: MyColors.primary,
              ),
            ),
            Text(
              'Please add a few items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MyColors.light,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: primaryButton(
                  text: "Continue browsing",
                  onPressed: () {
                    ShopCubit.get(context).changeBottomNav(0);
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      );
}
