import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/LoginResponse.dart';
import 'package:olx/model/app_exception.dart';
import 'package:olx/model/userCredit.dart';
import 'package:olx/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NetworkCommon {
  static final NetworkCommon _singleton = new NetworkCommon._internal();

  factory NetworkCommon() {
    return _singleton;
  }

  NetworkCommon._internal();

  final JsonDecoder _decoder = new JsonDecoder();

  // decode json response to dynamic (helper function)
/*
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
*/
  dynamic _returnResponse(Response response) {
    int status=response.statusCode;
    switch (status) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'خطأ من السيرفر يرجي المحاوله مره اخري : ${response.statusCode}');
    }
  }

  dynamic _returnError(DioError error) {
    int status=error.response.statusCode;
    switch (status) {

      case 400:
        throw BadRequestException();
      case 401:
      case 403:
        throw UnauthorisedException();
      case 500:
      default:
        throw FetchDataException(
            'خطأ من السيرفر يرجي المحاوله مره اخري : ');
    }
  }

  // global configration
  Dio get dio {
    Dio dio = new Dio();
    Dio refreshTokenDio = new Dio();

    // set base url
    // handle timeouts
    dio.options.connectTimeout = 20000; //5s
    dio.options.receiveTimeout = 20000;

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {

      // set the token
      String token = await preferences.getToken();
      if (token != null) {
        options.headers["Authorization"] = "Bearer " + token;
      }

      // set accept language
      /*String lang = await prefs.getLang();
      if (lang != null) {
        options.headers["Accept-Language"] = lang;
      }*/

      // print requests
      print("Pre request:${options.method},${options.baseUrl}${options.path}");
      print("Pre request:${options.headers.toString()}");
      print("Pre request:${options.data.toString()}");
      print("Pre request:${options.queryParameters.toString()}");


      return options; //continue
    },
        onError: (DioError error) async{
          print(
              "<-- ${error.response.statusCode}  ${error.response.request.path}");
          if (error.response?.statusCode == 401 && error.response?.data['sub_status'] == 42) {
            RequestOptions options = error.request;

            // If the token has been updated, repeat directly.
            String accessToken = await preferences.getToken();

            String token = "Bearer $accessToken";
            if (token != options.headers["Authorization"]) {
              options.headers["Authorization"] = token;
              return dio.request(options.path, options: options);
            }
            // Lock to block the incoming request until the token updated
            dio.lock();
            dio.interceptors.responseLock.lock();
            dio.interceptors.errorLock.lock();

            try {
               UserCredit credit=await preferences.getUserCredit();
              Response responseRefresh = await refreshTokenDio.post(
                  "${options.baseUrl}/api/token",
                  data: 'grant_type=password&username=${credit.userName}&password=${credit.password}',
                  options: Options(

                  )
              );

               LoginResponse userResponse=LoginResponse.fromJson(responseRefresh.data);
              //update token based on the new refresh token
              options.headers["Authorization"] = "Bearer ${userResponse.accessToken}";
              // Save the new token on shared or LocalStorage
              await preferences.setToken(userResponse);

              dio.unlock();
              dio.interceptors.responseLock.unlock();
              dio.interceptors.errorLock.unlock();

              // repeat the request with a new options
              return dio.request(options.path, options: options);

            } catch (e) {
            }
          }
          return error;



        },



        onResponse: (Response response) async {

      final int statusCode = response.statusCode;
      print(
          "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
      // handel response for some endpoints
      if (statusCode == 200 || statusCode == 201) {
        if (response.request.path == "login/" ||
            response.request.path == "signup/" ||
            response.request.path == APIConstants.LOGIN ||
            response.request.path == "login-google/" ||
            response.request.path == "login-facebook/") {

          final JsonDecoder _decoder = new JsonDecoder();
          final resultContainer = _decoder.convert(response.toString());
           preferences.setToken(LoginResponse.fromJson(resultContainer));
        }
        if (response.request.path == "profile/") {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final JsonDecoder _decoder = new JsonDecoder();
          final JsonEncoder _encoder = new JsonEncoder();
          final resultContainer = _decoder.convert(response.toString());
          prefs.setString("user", _encoder.convert((resultContainer as Map)));
        }
      }else if(response.statusCode==401 &&response.statusCode==403){













      }


      // log response
      print(
          "Response From:${response.request.method},${response.request.baseUrl}${response.request.path}");
      print("Response From:${response.toString()}");
      _returnResponse(response);
      return response; // continue
    }



    ));
    return dio;
  }
}