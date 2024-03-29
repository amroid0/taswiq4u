import 'package:olx/model/Cities.dart';
import 'package:olx/model/cityModel.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class CountryClient {


  Future<List<CountryEntity>> getCountryList() async {
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.COUNTRY_API);
    if (results.statusCode == 200) {
      final suggestions = results.data;
      return suggestions
          .map<CountryEntity>((json) => CountryEntity.fromJson(json))
          .toList(growable: false);
    } else {
      new CountryEntity(name: "");
    }
  }

  Future<List<CityModel>> getCityList(int countryID) async {
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.CITY_API, queryParameters: {"countryId": countryID});
    if (results.statusCode == 200) {
      final suggestions = results.data;
      return suggestions
          .map<CityModel>((json) => CityModel.fromJson(json))
          .toList(growable: false);
    } else {
      new CityModel(name: "");
    }
  }
  Future<List<Cities>> getAllCitiesById(int cityid) async{
    final results = await NetworkCommon()
        .dio
        .get(APIConstants.CITIES_API,queryParameters: {"cityId":cityid});
    if(results.statusCode==200){
      final suggestions = results.data;
      return suggestions
          .map<Cities>((json) => Cities.fromMap(json))
          .toList(growable: false);
    }else {
    new Cities(englishName: "");
    }

  }

}