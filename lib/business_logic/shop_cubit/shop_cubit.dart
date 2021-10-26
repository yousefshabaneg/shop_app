import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/api/dio_helper.dart';
import 'package:shop_app/data/models/shop_app/categories_model.dart';
import 'package:shop_app/data/models/shop_app/home_model.dart';
import 'package:shop_app/presentation/screens/categories_screen.dart';
import 'package:shop_app/presentation/screens/favorites_screen.dart';
import 'package:shop_app/presentation/screens/products_screen.dart';
import 'package:shop_app/presentation/screens/settings_screen.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/constants/end_points.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categories'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: home, token: token).then((json) {
      homeModel = HomeModel.fromJson(json);
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print('GET Home Model ERROR');
      emit(ShopErrorHomeDataState(error));
      print(error.toString());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategories() {
    DioHelper.getData(url: categories, token: token).then((categories) {
      categoriesModel = CategoriesModel.fromJson(categories);
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print('GET Categories ERROR');
      emit(ShopErrorCategoriesState(error));
      print(error.toString());
    });
  }
}
