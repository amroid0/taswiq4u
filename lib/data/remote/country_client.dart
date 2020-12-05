import 'package:olx/model/country_entity.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class CountryClient{


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
  Future<List<CountryEntity>> getCityList( int countryID) async {
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.CITY_API,queryParameters: {"countryId":countryID});
    if(results.statusCode==200){
      final suggestions = results.data;
      return suggestions
          .map<CountryEntity>((json) => CountryEntity.fromJson(json))
          .toList(growable: false);
    }else{
      new CountryEntity(name: "");
    }
  }



}