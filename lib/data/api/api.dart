import 'package:dio/dio.dart';
import 'package:shop_app/shared/constants/strings.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  static Future<List<dynamic>> getData(
      {required Map<String, dynamic> query}) async {
    try {
      Response response = await dio.get('URL', queryParameters: query);
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
