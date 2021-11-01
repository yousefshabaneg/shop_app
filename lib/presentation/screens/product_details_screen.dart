import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel;
  PageController _controller = PageController();
  var description = [];
  var descriptionSplit = [];

  ProductDetailsScreen({required this.productModel});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        description = productModel.description.split("\r\n");
        return Scaffold(
          appBar: AppBar(),
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              ConditionalBuilder(
                condition: cubit.homeModel != null,
                builder: (context) =>
                    buildProductDetails(productModel, context),
                fallback: (context) => buildProgressIndicator(),
              ),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: [
                    ShopCubit.get(context).productsQuantity[productModel.id] ==
                            null
                        ? Container(
                            width: 200,
                            height: 40,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: MyColors.secondary,
                              ),
                              onPressed: () {
                                ShopCubit.get(context)
                                    .changeCartItem(productModel.id);
                              },
                              icon: Icon(Icons.add_shopping_cart),
                              label: Text(
                                'Add to cart',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.light,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ShopCubit.get(context)
                                      .changeQuantityItem(productModel.id);
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: MyColors.light,
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
                                '${ShopCubit.get(context).productsQuantity[productModel.id] != null ? ShopCubit.get(context).productsQuantity[productModel.id] : 1}',
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
                                    productModel.id,
                                    increment: false,
                                  );
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: MyColors.dark,
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
                        ShopCubit.get(context).changeFavorites(productModel.id);
                      },
                      icon: CircleAvatar(
                        radius: 15,
                        child: Icon(
                          ShopCubit.get(context).favorites[productModel.id]!
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildProductDetails(ProductModel model, context) {
    descriptionSplit.clear();
    splitDescription();
    var length = descriptionSplit.length;
    print("Desc : $description");
    print("Desc Split : $descriptionSplit");
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.name.split(" ")[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: MyColors.primary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 25,
                      child: Text(
                        "4.4",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "(15 ratings)",
                      style: TextStyle(
                        color: MyColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              model.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 1.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    itemBuilder: (context, index) => Image(
                      image: NetworkImage(model.images[index]),
                    ),
                    itemCount: model.images.length,
                    physics: BouncingScrollPhysics(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: model.images.length,
                  axisDirection: Axis.horizontal,
                  effect: ExpandingDotsEffect(
                    activeDotColor: MyColors.primary,
                    dotColor: MyColors.dark,
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 4,
                    spacing: 5,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          NumberFormat.currency(decimalDigits: 0, symbol: "")
                              .format(model.price),
                          style: TextStyle(
                            fontSize: 22,
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          ' LE',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (model.discount > 0)
                      Text(
                        ' ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.oldPrice)} LE',
                        style: TextStyle(
                          fontSize: 18,
                          color: MyColors.dark,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
                if (model.discount > 0)
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
            MyDivider(),
            Row(
              children: [
                Text(
                  "Free delivery",
                  style: TextStyle(
                    color: MyColors.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " by ",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${DateFormat.MMMEd().format(DateTime.now())}",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
            Text(
              "Order in 1h 56m",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            MyDivider(),
            Text(
              "Offer Details",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.assignment_return_outlined,
                  size: 25,
                  color: Colors.orangeAccent,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Enjoy hassle free returns with this offer",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            MyDivider(),
            Row(
              children: [
                Icon(
                  Icons.library_add_check_outlined,
                  size: 25,
                  color: Colors.orangeAccent,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "1 year warranty",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            MyDivider(),
            Row(
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 25,
                  color: Colors.orangeAccent,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Sold By",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "OBAY",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
            MyDivider(),
            Text(
              "Specifications",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            descriptionSplit.length > 3
                ? Container(
                    height: (length * 1500) / 25,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) =>
                          specificationRow(descriptionSplit[index], index),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5,
                      ),
                      itemCount: length > 25 ? 25 : length,
                    ),
                  )
                : Text(
                    model.description,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget specificationRow(string, index) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            brandAndDesc(string)[0],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Expanded(
            child: Container(
              width: 200,
              child: Text(
                brandAndDesc(string)[1],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget MyDivider() => Column(
        children: [
          SizedBox(
            height: 5,
          ),
          divider(),
          SizedBox(
            height: 5,
          ),
        ],
      );

  void splitDescription() {
    for (String string in description) {
      if (string.contains(":")) descriptionSplit.add(string);
      if (descriptionSplit.length == 25) break;
    }
  }

  List<String> brandAndDesc(string) {
    return string.split(":");
  }
}
