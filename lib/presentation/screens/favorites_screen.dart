import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/favorites_model.dart';
import 'package:shop_app/presentation/screens/products_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState)
          showToast(msg: state.model.message, state: ToastStates.SUCCESS);
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).itemsInFavorites > 0,
          builder: (context) => ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder: (context) => SingleChildScrollView(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
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
                              padding:
                                  const EdgeInsetsDirectional.only(top: 3.0),
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
                        itemBuilder: (context, index) => buildFavProduct(
                            ShopCubit.get(context)
                                .favoritesModel!
                                .data
                                .favData[index]
                                .product,
                            context,
                            state),
                        separatorBuilder: (context, index) => myDivider(),
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

  Widget buildFavProduct(ProductFavModel product, context, state) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
      child: Container(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image(
                image: NetworkImage(product.image),
                width: 130,
                height: 130,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (product.discount != 0)
                    Row(
                      children: [
                        Text(
                          'EGP ${product.oldPrice}  ',
                          style: TextStyle(
                            fontSize: 14,
                            color: MyColors.darkness,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          '${product.discount}% OFF',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Text(
                        'EGP ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        product.price.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 18,
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 40,
                        child: defaultButton(
                          text: 'Buy Now',
                          radius: 15,
                          onPressed: () {},
                          background: MyColors.info,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).decrementItems(product.id);
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
                      )
                    ],
                  ),
                ],
              ),
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
