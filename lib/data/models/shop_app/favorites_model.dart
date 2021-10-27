import 'package:shop_app/data/models/shop_app/home_model.dart';

class FavoritesModel {
  late bool status;
  late Data data;
  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  List<FavoritesData> favData = [];
  Data.fromJson(Map<String, dynamic> json) {
    favData = List.from(json['data'])
        .map((favData) => FavoritesData.fromJson(favData))
        .toList();
  }
}

class FavoritesData {
  late int id;
  late ProductFavModel product;
  FavoritesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = ProductFavModel.fromJson(json['product']);
  }
}

class ProductFavModel {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;
  late String description;

  ProductFavModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
