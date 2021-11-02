import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/search_model.dart';
import 'package:shop_app/presentation/screens/product_details_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class SearchScreen extends StatelessWidget {
  FocusNode _focusSearch = new FocusNode();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
                ShopCubit.get(context).clearSearchData();
              },
            ),
            title: _buildSearchField(context),
            actions: [
              IconButton(
                onPressed: () {
                  ShopCubit.get(context).clearSearchData();
                },
                icon: Icon(
                  Icons.clear,
                  color: MyColors.secondary,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ConditionalBuilder(
              condition: state is! SearchLoadingState,
              builder: (context) => ConditionalBuilder(
                condition: ShopCubit.get(context).searchModel != null,
                builder: (context) => ConditionalBuilder(
                  condition:
                      ShopCubit.get(context).searchModel!.data.total != 0,
                  builder: (context) => SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 0),
                          child: Row(
                            children: [
                              Text(
                                "Search Results",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.light.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${ShopCubit.get(context).searchModel!.data.total}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          itemBuilder: (context, index) => buildSearchProduct(
                              ShopCubit.get(context)
                                  .searchModel!
                                  .data
                                  .products[index],
                              context,
                              state),
                          itemCount:
                              ShopCubit.get(context).searchModel!.data.total,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  ),
                  fallback: (context) => buildNoSearchFound(context),
                ),
                fallback: (context) => buildTypeToSearch(context),
              ),
              fallback: (context) => buildSearchLoadingIndicator(),
            ),
          ),
        );
      },
    );
  }

  Widget buildNoSearchFound(context) => Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: MyColors.primaryColor,
                child: Icon(
                  Icons.search_off_sharp,
                  color: MyColors.secondary,
                  size: 60,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Sorry, No results found :(',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Did you mean: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MyColors.light,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ShopCubit.get(context).getSearch(keyWord: "Apple");
                      ShopCubit.get(context).controller.text = "Apple";
                    },
                    child: Text(
                      'Apple',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MyColors.green,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ShopCubit.get(context).getSearch(keyWord: "Nikon");
                      ShopCubit.get(context).controller.text = "Nikon";
                    },
                    child: Text(
                      'Nikon',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MyColors.green,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ShopCubit.get(context).getSearch(keyWord: "JBL");
                      ShopCubit.get(context).controller.text = "JBL";
                    },
                    child: Text(
                      'JBL',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MyColors.green,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildSearchField(context) => Form(
        key: formKey,
        child: TextFormField(
          controller: ShopCubit.get(context).controller,
          focusNode: _focusSearch,
          cursorColor: MyColors.card,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: MyColors.card,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: MyColors.card,
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors.card),
            ),
            filled: false,
            hintText: 'What are you looking for?',
            hintStyle: TextStyle(
              color: MyColors.card,
              fontSize: 17,
            ),
          ),
          style: TextStyle(
            color: MyColors.grey,
            fontSize: 18,
          ),
          onFieldSubmitted: (keyWord) {
            ShopCubit.get(context).getSearch(keyWord: keyWord);
          },
        ),
      );

  Widget buildSearchProduct(SearchProductModel model, context, state) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            ProductDetailsScreen(
                productModel: ShopCubit.get(context)
                    .homeModel!
                    .data
                    .products[ShopCubit.get(context).productsMap[model.id]]));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: MyColors.card,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
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
                          model.image,
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
                          model.name,
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
                                    color: MyColors.light,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
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
                  ShopCubit.get(context).productsQuantity[model.id] == null
                      ? primaryButton(
                          width: 130,
                          text: "Add To Cart",
                          onPressed: () {
                            ShopCubit.get(context).changeCartItem(model.id);
                          },
                          height: 35,
                          radius: 15,
                          fontSize: 18,
                          isUpperCase: false,
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
                              '${ShopCubit.get(context).productsQuantity[model.id] != null ? ShopCubit.get(context).productsQuantity[model.id] : 1}',
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
                                ShopCubit.get(context).changeQuantityItem(
                                  model.id,
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
                          ],
                        ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(model.id);
                    },
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor: MyColors.primaryColor,
                      child: Icon(
                        ShopCubit.get(context).favorites[model.id]!
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: MyColors.dark,
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

  Widget buildTypeToSearch(context) => Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/search.svg",
                width: 150,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Find a Products, Brands, ...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: primaryButton(
                    width: 200,
                    height: 40,
                    text: "Start Search",
                    onPressed: () {
                      _focusSearch.requestFocus();
                    }),
              ),
            ],
          ),
        ),
      );
}
