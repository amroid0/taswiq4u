import 'dart:convert';

import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/utils/Constants.dart';

class AdsCategoryClient{
Future<List<CateogryEntity>?> getCateogryList( ) async {
  final results = await NetworkCommon()
      .dio
      .get(
      APIConstants.CATEOGRY_ADS,
      queryParameters: {"countryId": await preferences.getCountryID()});
  if(results.statusCode==200){
  final suggestions = results.data;
  List<CateogryEntity>? list= suggestions
      .map<CateogryEntity>((json) => CateogryEntity.fromJson(json))
      .toList(growable: false);
  preferences.saveCateogryList(list);
  return list;
  }else{
    new CateogryEntity(name: "");
  }
}
Future<List<CateogryEntity>?> getSliderList( ) async {
  final results = await NetworkCommon()
      .dio
      .get(
      APIConstants.SLIDER_ADS+"${preferences.getCountryID()}",
      queryParameters: {"categoryId": 1});
  if(results.statusCode==200){
    final suggestions = results.data;
    return suggestions
        .map<CateogryEntity>((json) => CateogryEntity.fromJson(json))
        .toList(growable: false);
  }else{
    new CateogryEntity(name: "");
  }
}
}