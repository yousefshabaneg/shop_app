class ChangeCartModel {
  late bool status;
  late String message;
  late CartData data;
  ChangeCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = CartData.fromJson(json['data']);
  }
}

class CartData {
  late int id;
  late int quantity;
  late CartProduct product;
  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = CartProduct.fromJson(json['product']);
  }
}

class CartProduct {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  String? name;
  String? description;
  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
