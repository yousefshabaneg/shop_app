import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/models/shop_app/categories_model.dart';
import 'package:shop_app/presentation/screens/category_item_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var categoriesList =
            ShopCubit.get(context).categoriesModel!.data.categoriesList;
        return Scaffold(
          body: Center(
            child: ListView.separated(
              itemBuilder: (context, index) =>
                  buildCategoryItem(categoriesList[index], context),
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemCount: categoriesList.length,
            ),
          ),
        );
      },
    );
  }

  Widget buildCategoryItem(DataModel model, context) => InkWell(
        onTap: () {
          ShopCubit.get(context).getCategoryData(categoryId: model.id);
          navigateTo(context, CategoryItemScreen(name: model.name));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                height: 110,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
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
              Container(
                child: Text(
                  model.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 1.0,
                        color: Colors.grey.shade600,
                      ),
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 1.0,
                        color: Color.fromARGB(50, 0, 0, 50),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
}
