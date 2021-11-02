import 'package:shop_app/data/models/shop_app/home_model.dart';
import 'package:shop_app/shared/constants/strings.dart';

class CategoriesModel {
  late bool status;
  late CategoriesDataModel data;
  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel {
  late int currentPage;
  late List<DataModel> categoriesList;

  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    categoriesList = List.from(json['data'])
        .map((dataModel) => DataModel.fromJson(dataModel))
        .toList();
  }
}

class DataModel {
  late int id;
  late String name;
  late String image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = images[id]!;
  }

  Map<int, String> images = {
    44: electronicImage,
    43: coronaImage,
    42: sportsImage,
    40: lightingImage
  };
}

class CategoryItemModel {
  late bool status;
  late CategoryData data;
  CategoryItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoryData.fromJson(json['data']);
  }
}

class CategoryData {
  late int total;
  List<ProductModel> products = [];
  CategoryData.fromJson(Map<String, dynamic> json) {
    total = json["total"];
    products =
        List.from(json["data"]).map((e) => ProductModel.fromJson(e)).toList();
  }
}
