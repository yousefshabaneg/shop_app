import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/data/api/dio_helper.dart';
import 'package:shop_app/data/models/shop_app/ChangeFavoritesModel.dart';
import 'package:shop_app/data/models/shop_app/add_cart_model.dart';
import 'package:shop_app/data/models/shop_app/address_model.dart';
import 'package:shop_app/data/models/shop_app/categories_model.dart';
import 'package:shop_app/data/models/shop_app/favorites_model.dart';
import 'package:shop_app/data/models/shop_app/get_carts_model.dart';
import 'package:shop_app/data/models/shop_app/home_model.dart';
import 'package:shop_app/data/models/shop_app/login_model.dart';
import 'package:shop_app/data/models/shop_app/update_cart_model.dart';
import 'package:shop_app/presentation/screens/categories_screen.dart';
import 'package:shop_app/presentation/screens/favorites_screen.dart';
import 'package:shop_app/data/models/shop_app/order_model.dart';
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

  List<Widget> bottomItems = [
    Icon(Icons.home),
    Icon(Icons.apps),
    Icon(Icons.favorite),
    Icon(Icons.settings),
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

  Map<int, int> productCartIds = {};
  var productsQuantity = {};
  Set cartItemsIds = {};
  var totalCarts = 0;
  void getQuantities() {
    totalCarts = 0;
    if (productsQuantity.isNotEmpty) {
      productsQuantity.forEach((key, value) {
        totalCarts += (value as int);
      });
    }
  }

  GetCartModel? cartModel;
  void getCartData() {
    emit(ShopLoadingCartDataState());
    DioHelper.getData(url: Carts, token: token).then((json) {
      cartModel = GetCartModel.fromJson(json);
      cartModel!.data.cartItems.forEach((element) {
        productCartIds[element.product.id] = element.id;
        productsQuantity[element.product.id] = element.quantity;
      });
      cartItemsIds.addAll(productCartIds.values);
      emit(ShopSuccessCartDataState());
      getQuantities();
    }).catchError((error) {
      print('GET Cart Data ERROR');
      print(error.toString());
      emit(ShopErrorCartDataState(error));
    });
  }

  ChangeCartModel? cartItem;

  void changeCartItem(int productId) {
    emit(ShopChangeCartItemState());
    var productQuantity = productsQuantity[productId];
    bool added = productQuantity == null;
    if (added) {
      productsQuantity[productId] = 1;
    } else {
      cartItemsIds.remove(productCartIds[productId]);
      productsQuantity.remove(productId);
      productCartIds.remove(productId);
    }
    DioHelper.postData(
      url: Carts,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      cartItem = ChangeCartModel.fromJson(value.data);
      emit(ShopSuccessChangeCartItemState(cartItem!));
      getCartData();
    }).catchError((error) {
      emit(ShopErrorChangeCartItemState());
      print("Error Change Cart Data $error");
    });
  }

  UpdateCartModel? updateCartModel;

  void changeQuantityItem(int productId, {bool increment = true}) {
    emit(ShopUpdateQuantityItemState());
    var cartId = productCartIds[productId];
    int quantity = productsQuantity[productId];
    if (increment && quantity >= 0)
      quantity++;
    else if (!increment && quantity > 1)
      quantity--;
    else if (!increment && quantity == 1) {
      quantity--;
      changeCartItem(productId);
      return;
    }
    productsQuantity[productId] = quantity;
    DioHelper.putData(
      url: "carts/$cartId",
      data: {"quantity": quantity},
      token: token,
    ).then((value) {
      updateCartModel = UpdateCartModel.fromJson(value.data);
      emit(ShopSuccessUpdateQuantityItemState(updateCartModel!));
      getCartData();
    }).catchError((error) {
      emit(ShopErrorUpdateQuantityItemState());
      print(error);
    });
  }

  void favChangeItems(int productId) {
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

  ShopLoginModel? userModel;
  void getUserData() {
    emit(ShopLoadingGetUserDataState());
    DioHelper.getData(url: Profile, token: token).then((data) {
      userModel = ShopLoginModel.fromJson(data);
      emit(ShopSuccessGetUserDataState(userModel!));
    }).catchError((error) {
      emit(ShopErrorGetUserDataState());
      print('Get User Model Error ${error.toString()}');
    });
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(UpdateProfileLoadingState());
    DioHelper.putData(
            url: UpdateProfile,
            data: {
              'name': name,
              'email': email,
              'phone': phone,
            },
            token: token)
        .then((value) {
      userModel!.status = value.data["status"];
      userModel!.message = value.data["message"];
      if (userModel!.status) userModel = ShopLoginModel.fromJson(value.data);
      emit(UpdateProfileSuccessState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(UpdateProfileErrorState(error));
    });
  }

  int addressId = 0;
  ChangeAddressModel? changeAddressModel;
  void addUserAddress(
      {required name, required city, required region, required details}) {
    deleteAddress = false;
    emit(AddAddressLoadingState());
    DioHelper.postData(
            url: Address,
            data: {
              'name': name,
              'city': city,
              'region': region,
              'details': details,
              "latitude": 30.0616863,
              "longitude": 31.3260088
            },
            token: token)
        .then((value) {
      changeAddressModel = ChangeAddressModel.fromJson(value.data);
      getAddresses();
      emit(AddAddressSuccessState(changeAddressModel!));
    }).catchError((error) {
      print('${error.toString()}');
      emit(AddAddressErrorState(error));
    });
  }

  bool isNewAddress = false;

  void changeUserAddress(
      {required name, required city, required region, required details}) {
    deleteAddress = false;
    emit(ChangeAddressLoadingState());
    DioHelper.putData(
            url: "addresses/$addressId",
            data: {
              'name': name,
              'city': city,
              'region': region,
              'details': details,
              "latitude": 30.0616863,
              "longitude": 31.3260088
            },
            token: token)
        .then((value) {
      changeAddressModel = ChangeAddressModel.fromJson(value.data);
      getAddresses();
      emit(ChangeAddressSuccessState(changeAddressModel!));
    }).catchError((error) {
      print("Change User Address Error : ${error.toString()}");
      emit(ChangeAddressErrorState(error));
    });
  }

  bool deleteAddress = false;
  void deleteUserAddress() {
    emit(DeleteAddressLoadingState());
    DioHelper.deleteData(url: "addresses/$addressId", token: token)
        .then((value) {
      changeAddressModel = ChangeAddressModel.fromJson(value.data);
      deleteAddress = true;
      emit(DeleteAddressSuccessState(changeAddressModel!));
      getAddresses();
    }).catchError((error) {
      print("Change User Address Error : ${error.toString()}");
      emit(DeleteAddressErrorState(error));
    });
  }

  GetAddressModel? addressModel;
  void getAddresses() {
    emit(GetAddressesLoadingState());
    DioHelper.getData(url: Address, token: token).then((address) {
      addressModel = GetAddressModel.fromJson(address);
      emit(GetAddressesSuccessState(addressModel!));
      if (addressModel!.data.data.length != 0) {
        addressId = addressModel!.data.data[0].id;
        isNewAddress = false;
      } else {
        addressId = 0;
        isNewAddress = true;
      }
    }).catchError((error) {
      emit(GetAddressesErrorState(error));
      print('Get Addresses Error ${error.toString()}');
    });
  }

  GetOrderModel? orderModel;
  void getOrders() {
    ordersDetails.clear();
    ordersIds.clear();
    emit(GetOrdersLoadingState());
    DioHelper.getData(url: Orders, token: token).then((orders) {
      orderModel = GetOrderModel.fromJson(orders);
      orderModel!.data.data.forEach((element) {
        ordersIds.add(element.id);
      });
      ordersIds.sort((b, a) => a.compareTo(b));
      emit(GetOrdersSuccessState(orderModel!));
      getOrdersDetails();
    }).catchError((error) {
      emit(GetOrdersErrorState(error));
      print('Get Orders Error ${error.toString()}');
    });
  }

  List<int> ordersIds = [];
  OrderDetailsModel? orderItemDetails;
  List<OrderDetailsModel> ordersDetails = [];

  void getOrdersDetails() async {
    emit(OrderDetailsLoadingState());
    if (ordersIds.isNotEmpty) {
      for (var id in ordersIds) {
        await DioHelper.getData(url: "$Orders/$id", token: token)
            .then((orderDetails) {
          orderItemDetails = OrderDetailsModel.fromJson(orderDetails);
          ordersDetails.add(orderItemDetails!);
          emit(OrderDetailsSuccessState(orderItemDetails!));
        }).catchError((error) {
          emit(OrderDetailsErrorState(error));
          print('Get Orders Details Error ${error.toString()}');
          return;
        });
      }
    }
  }

  AddOrderModel? addOrderModel;
  void addNewOrder() {
    emit(AddOrderLoadingState());
    DioHelper.postData(
            url: Orders,
            data: {
              'address_id': addressId,
              "payment_method": 1,
              "use_points": false,
            },
            token: token)
        .then((value) {
      addOrderModel = AddOrderModel.fromJson(value.data);
      if (addOrderModel!.status) {
        getCartData();
        productsQuantity.clear();
        cartItemsIds.clear();
        productCartIds.clear();
        getOrders();
        emit(AddOrderSuccessState(addOrderModel!));
      } else {
        getCartData();
        getOrders();
      }
    }).catchError((error) {
      print('${error.toString()}');
      emit(AddOrderErrorState(error));
    });
  }
}
