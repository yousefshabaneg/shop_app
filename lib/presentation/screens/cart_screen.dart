import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/get_carts_model.dart';
import 'package:shop_app/presentation/screens/address_screen.dart';
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
                    color: MyColors.info,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    '( ${ShopCubit.get(context).totalCarts} Items)',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
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
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                        height: 25,
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
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: ConditionalBuilder(
                      condition: ShopCubit.get(context).addressId != 0,
                      builder: (context) => BottomAppBar(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: state is! AddOrderLoadingState
                              ? defaultButton(
                                  text:
                                      'Checkout ( ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(ShopCubit.get(context).cartModel!.data.total)} LE )',
                                  onPressed: () {
                                    ShopCubit.get(context).addNewOrder();
                                  },
                                  fontSize: 20,
                                  radius: 30,
                                  background: Color(0xff003FFF),
                                )
                              : buildProgressIndicator(),
                        ),
                      ),
                      fallback: (context) => BottomAppBar(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: defaultButton(
                            text: 'Add your address to continue checkout.',
                            onPressed: () {
                              navigateTo(context, AddressScreen());
                            },
                            fontSize: 14,
                            radius: 30,
                            background: Color(0xff003FFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildInCartProduct(CartItem model, total, context, state) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Image(
                    image: NetworkImage(
                      model.product.image,
                    ),
                    width: 150,
                    height: 150,
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
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
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
                                ),
                              ),
                            ],
                          ),
                          if (model.product.discount > 0)
                            Text(
                              ' ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.product.oldPrice)} LE',
                              style: TextStyle(
                                fontSize: 15,
                                color: MyColors.darkness,
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
                            color: MyColors.info,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
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
                                ? MyColors.darkness
                                : MyColors.info,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
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
                    child: Icon(
                      ShopCubit.get(context).favorites[model.product.id]!
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      size: 18,
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
    );
  }

  Widget buildNoCartItems(context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.shopping_cart_sharp,
                size: 60,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'There are no products in your Cart',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: MyColors.primary,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            defaultButton(
              text: 'Continue Shopping',
              onPressed: () {
                ShopCubit.get(context).changeBottomNav(0);
                Navigator.pop(context);
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
