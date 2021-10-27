import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/api/dio_helper.dart';
import 'package:shop_app/data/models/shop_app/ChangeFavoritesModel.dart';
import 'package:shop_app/data/models/shop_app/categories_model.dart';
import 'package:shop_app/data/models/shop_app/favorites_model.dart';
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
    DioHelper.getData(url: Home, token: token).then((json) {
      homeModel = HomeModel.fromJson(json);
      homeModel!.data.products.forEach((element) {
        favorites[element.id] = element.inFavorites;
      });
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print('GET Home Model ERROR');
      emit(ShopErrorHomeDataState(error));
      print(error.toString());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategories() {
    DioHelper.getData(url: Categories, token: token).then((categories) {
      categoriesModel = CategoriesModel.fromJson(categories);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print('GET Categories ERROR');
      emit(ShopErrorCategoriesState(error));
      print(error.toString());
    });
  }

  Map<int, bool> favorites = {};
  var itemsInFavorites = 0;

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: Favorites,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(changeFavoritesModel!.status);
      if (!changeFavoritesModel!.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  void decrementItems(int productId) {
    emit(ShopDecrementFavItems());
    changeFavorites(productId);
  }

  FavoritesModel? favoritesModel;
  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(url: Favorites, token: token).then((favorites) {
      favoritesModel = FavoritesModel.fromJson(favorites);
      itemsInFavorites = favoritesModel!.data.favData.length;
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      emit(ShopErrorGetFavoritesState());
      print('Get Favorites Error ${error.toString()}');
    });
  }
}
