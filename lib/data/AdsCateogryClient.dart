import 'dart:convert';

import 'package:olx/data/NetworkCommon.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/utils/Constants.dart';

class AdsCategoryClient{
final String BASE_PATH="CommercialAdCategory/GetAllCountryCategory";
Future<List<CateogryEntity>> getCateogryList( ) async {
  final results = await NetworkCommon().dio.get(APIConstants.API_BASE_ENDPOINT + BASE_PATH,
      queryParameters: {"countryId": 1});
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