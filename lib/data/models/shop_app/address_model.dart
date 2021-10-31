/*
{
    "status": true,
    "message": "تمت الإضافة بنجاح",
    "data": {
        "name": "Work",
        "city": "Cairo",
        "region": "Nasr City",
        "details": "7 Wahran str",
        "latitude": 30.061686300000001637044988456182181835174560546875,
        "longitude": 31.326008800000000320551407639868557453155517578125,
        "id": 728
    }
}
 */
class GetAddressModel {
  late bool status;
  String? message;
  late GetAddressData data;
  GetAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = GetAddressData.fromJson(json['data']);
  }
}

class GetAddressData {
  List<AddressData> data = [];
  GetAddressData.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => AddressData.fromJson(e)).toList();
  }
}

class ChangeAddressModel {
  late bool status;
  String? message;
  late AddressData data;
  ChangeAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = AddressData.fromJson(json['data']);
  }
}

class AddressData {
  late int id;
  late String name;
  late String city;
  late String region;
  late String details;
  AddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    region = json['region'];
    details = json['details'];
  }
}
