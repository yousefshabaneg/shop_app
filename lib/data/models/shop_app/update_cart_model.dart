import 'package:shop_app/data/models/shop_app/add_cart_model.dart';

class UpdateCartModel {
  late bool status;
  late String message;
  UpdateCart? data;
  UpdateCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = UpdateCart.fromJson(json['data']);
  }
}

class UpdateCart {
  late UpdateCartData cart;
  late dynamic total;
  UpdateCart.fromJson(Map<String, dynamic> json) {
    cart = UpdateCartData.fromJson(json['cart']);
    total = json['total'];
  }
}

class UpdateCartData {
  late int id;
  late int quantity;
  late CartProduct product;
  UpdateCartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = int.parse(json['quantity']);
    product = CartProduct.fromJson(json['product']);
  }
}
