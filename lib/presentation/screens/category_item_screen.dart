import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/categories_model.dart';
import 'package:shop_app/data/models/shop_app/home_model.dart';
import 'package:shop_app/presentation/screens/product_details_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class CategoryItemScreen extends StatelessWidget {
  final String name;

  CategoryItemScreen({required this.name});
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
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              name.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 0.4,
              ),
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
                ShopCubit.get(context).categoryItemModel = null;
              },
            ),
          ),
          body: ConditionalBuilder(
            condition: cubit.categoryItemModel != null,
            builder: (context) => ConditionalBuilder(
              condition: cubit.categoryItemModel!.data.total > 0,
              builder: (context) => categoryItemBuilder(
                  cubit.categoryItemModel!, cubit.categoriesModel!, context),
              fallback: (context) => buildNoItemsInCategory(context),
            ),
            fallback: (context) => buildSearchLoadingIndicator(),
          ),
        );
      },
    );
  }

  Widget categoryItemBuilder(CategoryItemModel catItemModel,
          CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1 / 2,
                children: List.generate(
                  catItemModel.data.products.length,
                  (index) => buildGridProduct(
                      catItemModel.data.products[index], context),
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      );

  Widget positionedFill(text) => Positioned.fill(
        child: Align(
          alignment: Alignment(1, -1),
          child: ClipRect(
            child: Banner(
              message: "Sale",
              textStyle: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
              location: BannerLocation.topEnd,
              color: MyColors.red,
              child: Container(
                height: 100,
              ),
            ),
          ),
        ),
      );

  Widget buildNoItemsInCategory(context) => Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: MyColors.primaryColor,
                child: Icon(
                  Icons.warning_amber_outlined,
                  color: MyColors.secondary,
                  size: 60,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Sorry, this section does not contain products yet :(',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: primaryButton(
                    text: "Back to categories",
                    onPressed: () {
                      ShopCubit.get(context).categoryItemModel = null;
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      );

  Widget buildGridProduct(ProductModel product, context) => Container(
        child: Card(
          color: MyColors.card,
          elevation: 3,
          margin: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment(-1, -1),
                children: [
                  InkWell(
                    onTap: () {
                      navigateTo(
                          context, ProductDetailsScreen(productModel: product));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Image(
                          image: NetworkImage(product.image),
                          // fit: BoxFit.cover,
                          height: 180,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(product.id);
                    },
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor: MyColors.primaryColor,
                      child: Icon(
                        ShopCubit.get(context).favorites[product.id]!
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: MyColors.dark,
                        size: 18,
                      ),
                    ),
                  ),
                  if (product.discount > 0) positionedFill(product.discount),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: MyColors.light,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (product.discount > 0)
                      Row(
                        children: [
                          Text(
                            'Save ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(product.oldPrice - product.price)} (${product.discount}%)',
                            style: TextStyle(
                              color: MyColors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          NumberFormat.currency(decimalDigits: 0, symbol: "")
                              .format(product.price),
                          style: TextStyle(
                            fontSize: 18,
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          ' LE  ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: MyColors.light,
                          ),
                        ),
                      ],
                    ),
                    if (product.discount > 0)
                      Text(
                        ' ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(product.oldPrice)} LE',
                        style: TextStyle(
                          fontSize: 15,
                          color: MyColors.light.withOpacity(0.6),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ShopCubit.get(context).productsQuantity[product.id] ==
                        null
                    ? primaryButton(
                        text: "Add To Cart",
                        onPressed: () {
                          ShopCubit.get(context).changeCartItem(product.id);
                        },
                        height: 35,
                        radius: 15,
                        fontSize: 18,
                        isUpperCase: false,
                      )
                    : Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  ShopCubit.get(context)
                                      .changeQuantityItem(product.id);
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
                            ),
                            Text(
                              ShopCubit.get(context)
                                  .productsQuantity[product.id]
                                  .toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  ShopCubit.get(context).changeQuantityItem(
                                    product.id,
                                    increment: false,
                                  );
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
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
}
