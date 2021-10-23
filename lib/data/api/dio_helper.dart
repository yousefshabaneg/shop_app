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
      headers: {'Content-Type': 'application/json'},
    );
    dio = Dio(options);
  }

  static Map<String, dynamic> _headers(lang, token) => {
        'lang': lang,
        'Authorization': token ?? '',
        'Content-Type': 'application/json',
      };

  static Future<List<dynamic>> getData({
    required String url,
    required Map<String, dynamic> query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = _headers(lang, token);
    try {
      Response response = await dio.get(url, queryParameters: query);
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = _headers(lang, token);

    return dio.post(url, queryParameters: query, data: data);
  }
}
