class ShopLoginModel {
  late bool status;
  late String? message;
  UserData? data;

  ShopLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String image;
  late dynamic points;
  late dynamic credit;
  late String token;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];
  }
}

class ChangePasswordModel {
  late bool status;
  late String message;
  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
  }
}

class LogoutModel {
  late bool status;
  late String message;
  LogoutModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
  }
}
