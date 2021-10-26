import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/categories_model.dart';
import 'package:shop_app/data/models/shop_app/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null,
          builder: (context) =>
              homeBuilder(cubit.homeModel!, cubit.categoriesModel!),
          fallback: (context) => buildProgressIndicator(),
        );
      },
    );
  }

  Widget homeBuilder(HomeModel homeModel, CategoriesModel categoriesModel) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: homeModel.data.banners
                  .map((banner) => Image(
                        image: NetworkImage(banner.image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 230,
                reverse: false,
                viewportFraction: 1,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: 1500),
                autoPlayInterval: Duration(seconds: 7),
                autoPlayCurve: Curves.easeInOutQuint,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: MyColors.secondary,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 110,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategories(
                          categoriesModel.data.categoriesList[index]),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 5,
                      ),
                      itemCount: categoriesModel.data.categoriesList.length,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: MyColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 5,
              childAspectRatio: 1 / 1.8,
              children: List.generate(
                homeModel.data.products.length,
                (index) => buildGridProduct(homeModel.data.products[index]),
              ),
            ),
          ],
        ),
      );

  Widget buildGridProduct(ProductModel product) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 1, 5, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: NetworkImage(product.image),
                width: double.infinity,
                height: 200,
              ),
            ),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
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
                Spacer(),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      color: MyColors.primaryColor,
                    ))
              ],
            ),
          ],
        ),
      );

  Widget buildCategories(DataModel model) => Container(
        width: 120,
        child: Column(
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: MyColors.primary,
                    width: 3,
                    style: BorderStyle.solid),
                image: new DecorationImage(
                  image: NetworkImage(model.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              model.name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
}
