import 'home_model.dart';

class GetCartModel {
  late bool status;
  late GetCartData data;
  GetCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = GetCartData.fromJson(json['data']);
  }
}

class GetCartData {
  List<CartItem> cartItems = [];
  late int total;
  GetCartData.fromJson(Map<String, dynamic> json) {
    cartItems =
        List.from(json['cart_items']).map((e) => CartItem.fromJson(e)).toList();
    total = json['total'];
  }
}

class CartItem {
  late int id;
  late int quantity;
  late ProductModel product;
  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = ProductModel.fromJson(json['product']);
  }
}
