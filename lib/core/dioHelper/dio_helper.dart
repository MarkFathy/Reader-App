import 'package:dio/dio.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';

import '../../constant.dart';

class DioHelper {
  static final _baseUrl = 'http://$ip/api/v1/';
 // static final _baseUrl = 'https://scanner.elhsnaaa-eg.com/api/v1/';

  static Dio dioSingleton = Dio()..options.baseUrl = _baseUrl;

  static Future<Response<dynamic>> post(String path, bool isAuh,
      {FormData? formData,
      Map<String, dynamic>? body,
      Function(int, int)? onSendProgress}) {
    print('lsdkslkdsl'+ _baseUrl);
    dioSingleton.options.headers = isAuh
        ? {
            'Authorization': 'Bearer ${AppStorage.getToken}',
            'Accept-Language':  'en'
          }
        : null;
    final response = dioSingleton.post(path,
        data: formData ?? FormData.fromMap(body!),
        options: Options(
            headers: {
              'Authorization': 'Bearer ${AppStorage.getToken}',
              'Accept': 'application/json',
              'Accept-Language':  'en'
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
        onSendProgress: onSendProgress);
    return response;
  }

  static Future<Response<dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
  }) {
    try {
      dioSingleton.options.headers = {
        'Authorization': 'Bearer ${AppStorage.getToken}',
        'Accept-Language': 'en'
      };
      final response = dioSingleton.delete(
        path,
        data: body,
        options: Options(
            headers: {
              'Authorization': 'Bearer ${AppStorage.getToken}',
              'Accept': 'application/json',
              'Accept-Language' :'en'
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  static Future<Response<dynamic>>? get(String path) {
    if (AppStorage.isLogged) {
      dioSingleton.options.headers = {
        'Authorization': 'Bearer ${AppStorage.getToken}',
        'Accept-Language':  'en'
      };
    }
    final response = dioSingleton.get(path);
    dioSingleton.options.headers = null;
    return response;
  }

  // static Future<void>? launchURL(url) async {
  //   if (!await launch(url)) throw 'Could not launch $url';
  // }
}
