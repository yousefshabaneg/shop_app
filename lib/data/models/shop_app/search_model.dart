class SearchModel {
  late bool status;
  late SearchData data;
  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = SearchData.fromJson(json["data"]);
  }
}

class SearchData {
  List<SearchProductModel> products = [];
  late dynamic total;
  SearchData.fromJson(Map<String, dynamic> json) {
    products = List.from(json["data"])
        .map((e) => SearchProductModel.fromJson(e))
        .toList();
    total = json["total"];
  }
}

class SearchProductModel {
  late int id;
  late dynamic price;
  late String image;
  List<String> images = [];
  late String name;
  late String description;
  late bool inFavorites;
  late bool inCart;
  SearchProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    name = json['name'];
    image = json['image'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
    description = json['description'];
  }
}
