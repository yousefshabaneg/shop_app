import 'package:shop_app/data/models/shop_app/ChangeFavoritesModel.dart';
import 'package:shop_app/data/models/shop_app/add_cart_model.dart';
import 'package:shop_app/data/models/shop_app/address_model.dart';
import 'package:shop_app/data/models/shop_app/favorites_model.dart';
import 'package:shop_app/data/models/shop_app/home_model.dart';
import 'package:shop_app/data/models/shop_app/login_model.dart';
import 'package:shop_app/data/models/shop_app/search_model.dart';
import 'package:shop_app/data/models/shop_app/update_cart_model.dart';
import 'package:shop_app/data/models/shop_app/order_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {
  final String error;

  ShopErrorHomeDataState(this.error);
}

class ShopLoadingCategoryItemDataState extends ShopStates {}

class ShopSuccessCategoryItemDataState extends ShopStates {}

class ShopErrorCategoryItemDataState extends ShopStates {
  final String error;

  ShopErrorCategoryItemDataState(this.error);
}

class ShopLoadingCartDataState extends ShopStates {}

class ShopSuccessCartDataState extends ShopStates {}

class ShopErrorCartDataState extends ShopStates {
  final String error;

  ShopErrorCartDataState(this.error);
}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {
  final String error;

  ShopErrorCategoriesState(this.error);
}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {}

class ShopChangeCartItemState extends ShopStates {}

class ShopSuccessChangeCartItemState extends ShopStates {
  final ChangeCartModel model;

  ShopSuccessChangeCartItemState(this.model);
}

class ShopErrorChangeCartItemState extends ShopStates {}

class ShopUpdateQuantityItemState extends ShopStates {}

class ShopSuccessUpdateQuantityItemState extends ShopStates {
  final UpdateCartModel model;

  ShopSuccessUpdateQuantityItemState(this.model);
}

class ShopErrorUpdateQuantityItemState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingGetUserDataState extends ShopStates {}

class ShopSuccessGetUserDataState extends ShopStates {
  final ShopLoginModel userModel;
  ShopSuccessGetUserDataState(this.userModel);
}

class ShopErrorGetUserDataState extends ShopStates {}

class UpdateProfileSuccessState extends ShopStates {
  final ShopLoginModel loginModel;

  UpdateProfileSuccessState(this.loginModel);
}

class UpdateProfileLoadingState extends ShopStates {}

class UpdateProfileErrorState extends ShopStates {
  final String error;

  UpdateProfileErrorState(this.error);
}

class AddAddressLoadingState extends ShopStates {}

class AddAddressSuccessState extends ShopStates {
  final ChangeAddressModel addressModel;

  AddAddressSuccessState(this.addressModel);
}

class AddAddressErrorState extends ShopStates {
  final String error;

  AddAddressErrorState(this.error);
}

class ChangeAddressLoadingState extends ShopStates {}

class ChangeAddressSuccessState extends ShopStates {
  final ChangeAddressModel addressModel;

  ChangeAddressSuccessState(this.addressModel);
}

class ChangeAddressErrorState extends ShopStates {
  final String error;

  ChangeAddressErrorState(this.error);
}

class DeleteAddressLoadingState extends ShopStates {}

class DeleteAddressSuccessState extends ShopStates {
  final ChangeAddressModel addressModel;

  DeleteAddressSuccessState(this.addressModel);
}

class DeleteAddressErrorState extends ShopStates {
  final String error;

  DeleteAddressErrorState(this.error);
}

class GetAddressesLoadingState extends ShopStates {}

class GetAddressesSuccessState extends ShopStates {
  final GetAddressModel addressModel;

  GetAddressesSuccessState(this.addressModel);
}

class GetAddressesErrorState extends ShopStates {
  final String error;

  GetAddressesErrorState(this.error);
}

class AddOrderLoadingState extends ShopStates {}

class AddOrderSuccessState extends ShopStates {
  final AddOrderModel addOrderModel;

  AddOrderSuccessState(this.addOrderModel);
}

class AddOrderErrorState extends ShopStates {
  final String error;

  AddOrderErrorState(this.error);
}

class CancelOrderLoadingState extends ShopStates {}

class CancelOrderSuccessState extends ShopStates {
  final CancelOrderModel cancelOrderModel;

  CancelOrderSuccessState(this.cancelOrderModel);
}

class CancelOrderErrorState extends ShopStates {
  final String error;

  CancelOrderErrorState(this.error);
}

class GetOrdersLoadingState extends ShopStates {}

class GetOrdersSuccessState extends ShopStates {
  final GetOrderModel getOrderModel;

  GetOrdersSuccessState(this.getOrderModel);
}

class GetOrdersErrorState extends ShopStates {
  final String error;

  GetOrdersErrorState(this.error);
}

class OrderDetailsLoadingState extends ShopStates {}

class OrderDetailsSuccessState extends ShopStates {
  final OrderDetailsModel orderDetailsModel;

  OrderDetailsSuccessState(this.orderDetailsModel);
}

class OrderDetailsErrorState extends ShopStates {
  final String error;

  OrderDetailsErrorState(this.error);
}

class ShopDecrementFavItems extends ShopStates {}

class SearchLoadingState extends ShopStates {}

class SearchSuccessState extends ShopStates {}

class SearchErrorState extends ShopStates {
  final String error;

  SearchErrorState(this.error);
}
