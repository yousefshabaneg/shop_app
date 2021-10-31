import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/favorites_model.dart';
import 'package:shop_app/presentation/screens/products_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class FavoritesScreen extends StatelessWidget {
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
        return ConditionalBuilder(
          condition: ShopCubit.get(context).itemsInFavorites > 0,
          builder: (context) => ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder: (context) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Text(
                          'My Wishlist  ',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: MyColors.info,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 3.0),
                          child: Text(
                            '(${ShopCubit.get(context).itemsInFavorites.toString()} items)',
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
                    itemBuilder: (context, index) => buildFavoriteProduct(
                        ShopCubit.get(context)
                            .favoritesModel!
                            .data
                            .favData[index]
                            .product,
                        context,
                        state),
                    separatorBuilder: (context, index) => divider(),
                    itemCount: ShopCubit.get(context)
                        .favoritesModel!
                        .data
                        .favData
                        .length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            ),
            fallback: (context) => buildProgressIndicator(),
          ),
          fallback: (context) => buildNoFavItems(context),
        );
      },
    );
  }

  Widget buildFavoriteProduct(ProductFavModel model, context, state) {
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
                      model.image,
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
                        model.name,
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
                      if (model.discount != 0)
                        Row(
                          children: [
                            Text(
                              'Save ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.oldPrice - model.price)} (${model.discount}%)',
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
                                    .format(model.price),
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
                          if (model.discount > 0)
                            Text(
                              ' ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.oldPrice)} LE',
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
                ShopCubit.get(context).productsQuantity[model.id] == null
                    ? Container(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: MyColors.info,
                          ),
                          onPressed: () {
                            ShopCubit.get(context).changeCartItem(model.id);
                          },
                          icon: Icon(Icons.add_shopping_cart),
                          label: Text('Add to cart'),
                        ),
                      )
                    : Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ShopCubit.get(context)
                                  .changeQuantityItem(model.id);
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
                            '${ShopCubit.get(context).productsQuantity[model.id] != null ? ShopCubit.get(context).productsQuantity[model.id] : 1}',
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
                              ShopCubit.get(context).changeQuantityItem(
                                model.id,
                                increment: false,
                              );
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
                    ShopCubit.get(context).changeFavorites(model.id);
                  },
                  icon: CircleAvatar(
                    radius: 15,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 18,
                      ),
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

  Widget buildNoFavItems(context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.favorite,
                size: 60,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'There are no products saved yet',
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
