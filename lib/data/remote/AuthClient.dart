import 'dart:convert';

import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/model/LoginResponse.dart';
import 'package:olx/model/RegisterRequest.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/model/userCredit.dart';
import 'package:olx/utils/Constants.dart';

import '../shared_prefs.dart';

class AuthClient{



  Future<bool> login(UserCredit credit) async {
  final results = await NetworkCommon().dio.post(APIConstants.LOGIN,
  data: 'grant_type=password&username=${ await preferences.getCountryID()}-${credit.userName}&password=${credit
      .password}',

  );
  if (results.statusCode == 200) {
  preferences.saveCredit(credit);
  preferences.setToken(LoginResponse.fromJson(results.data));
  return true;
  }
  }

  Future<bool> checkVerfiyPhone() async {
    final results = await NetworkCommon().dio.post(APIConstants.CHECK_VERIFY,

    );
    if (results.statusCode == 200) {
      if (results.data != null)
        return results.data as bool;
    }
  }

  Future<bool> updateToken(UserCredit credit) async {
  final results = await NetworkCommon().dio.post(APIConstants.LOGIN,
  data: 'grant_type=password&username=${ await preferences.getCountryID()}-${credit.userName}&password=${credit.password}',

  );
  if(results.statusCode==200){
  preferences.setToken(LoginResponse.fromJson(results.data));
  return true;
  }

  }

  Future<List<CateogryEntity>> getCateogryList( ) async {
  final results = await NetworkCommon()
      .dio
      .get(
  APIConstants.CATEOGRY_ADS,
  queryParameters: {"countryId": await preferences.getCountryID()});
  if(results.statusCode==200){
  final suggestions = results.data;
  return suggestions
      .map<CateogryEntity>((json) => CateogryEntity.fromJson(json))
      .toList(growable: false);
  }else{
  new CateogryEntity(name: "");
  }
  }

  Future<List<CountryEntity>> getCountryList( ) async {
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.COUNTRY_API);
    if(results.statusCode==200){
      final suggestions = results.data;
      return suggestions
          .map<CountryEntity>((json) => CountryEntity.fromJson(json))
          .toList(growable: false);
    }else{
      new CountryEntity(name: "");
    }
  }




  Future <bool> register(RegisterRequest reuqestObject)async {
  print(reuqestObject.toJson());
  final results = await NetworkCommon().dio.post(APIConstants.REGISTER_BASE_URL,
  data: jsonEncode(reuqestObject)
  );
  if(results.statusCode==200){
  return true;
  }else{
  return false;
  }

  }

  }








