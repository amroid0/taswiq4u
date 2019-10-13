import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:olx/model/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NetworkCommon {
  static final NetworkCommon _singleton = new NetworkCommon._internal();

  factory NetworkCommon() {
    return _singleton;
  }

  NetworkCommon._internal();

  final JsonDecoder _decoder = new JsonDecoder();

  // decode json response to dynamic (helper function)
  dynamic decodeResp(d) {
    var response = d as Response;
    final dynamic jsonBody = response.data;
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
      throw new Exception("statusCode: $statusCode");
    }

    if (jsonBody is String) {
      return _decoder.convert(jsonBody);
    } else {
      return jsonBody;
    }
  }
  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.data.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  // global configration
  Dio get dio {
    Dio dio = new Dio();

    // set base url
    dio.options.baseUrl = 'baseurl';
    // handle timeouts
    dio.options.connectTimeout = 20000; //5s
    dio.options.receiveTimeout = 20000;

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {

      // set the token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      token="jsJpNwkaIWp8RnDx-gKAtr9783Ev8qBcfD6nYCn2t_xrqvceEMNU9eiLm2QCQvrO7sLNJKp4UcQlkw4K-6Ugy-gebm3RoVyBWJrHNtV4ZDASuHYJnZ7A154CWZeAdqmiHCdDPJAN4HacSizeLcTtJP3Q3K1Y2TKjIavqtw3u0hgSrNdxYF-CR32J8vrACOGjwQUXigFxN7YdCKSkA7oGbjUZX7tRMRQOi840W0H8rVviVkjhbowxmcNWUHePFEQuvXb73iyrBtimeT-4CkHlzso9-WZWVHrEfYT3V2neN6wRQe9zoihtwjI89ZHXcqJZxHie5t6BUzR7jas38VGJPhFuniYZTqdsLT8EIXSlm6F4gajYOLz-zmfpNneDvYxEK3BZ0T1GXPKQZV_ia59YvA6fK8Mnca2N2mqe-Zd0QKkXOLXwcb5cjOxcyahHUeQHlqlry8Do7Zr2Hncq93FSZEHgCr5WO-mK9oJ0a-DheZ0";
      if (token != null) {
        options.headers["Authorization"] = "Bearer " + token;
      }

      // set accept language
      String lang = prefs.getString("lang");
      if (lang != null) {
        options.headers["Accept-Language"] = lang;
      }

      // print requests
      print("Pre request:${options.method},${options.baseUrl}${options.path}");
      print("Pre request:${options.headers.toString()}");

      return options; //continue
    }, onResponse: (Response response) async {

      final int statusCode = response.statusCode;

      // handel response for some endpoints
      if (statusCode == 200 || statusCode == 201) {
        if (response.request.path == "login/" ||
            response.request.path == "signup/" ||
            response.request.path == "login-google/" ||
            response.request.path == "login-facebook/") {

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final JsonDecoder _decoder = new JsonDecoder();
          final JsonEncoder _encoder = new JsonEncoder();
          final resultContainer = _decoder.convert(response.toString());

          prefs.setString("token", resultContainer["token"]);

          prefs.setString(
              "user", _encoder.convert((resultContainer["user"] as Map)));
          prefs.setBool("isLogined", true);
        }
        if (response.request.path == "profile/") {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final JsonDecoder _decoder = new JsonDecoder();
          final JsonEncoder _encoder = new JsonEncoder();
          final resultContainer = _decoder.convert(response.toString());
          prefs.setString("user", _encoder.convert((resultContainer as Map)));
        }
      }

      // log response
      print(
          "Response From:${response.request.method},${response.request.baseUrl}${response.request.path}");
      print("Response From:${response.toString()}");
      return response; // continue
    }));
    return dio;
  }
}