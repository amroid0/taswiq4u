import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/utils/Constants.dart';

class AdsClient{

  Future<AdsEntity> getCateogryList( int orderby) async {
    final results = await NetworkCommon().dio.post(APIConstants.SEARCH_WITH_PARAM,
        data: {
          "CountryId": 1,
          "CityId": 1,
          "CategoryId": 1

        },queryParameters: {"orderBy":orderby}

        );
    return  AdsEntity.fromJson(results.data);
  }

  Future<List<FieldProprtiresEntity>> getAdsFieldsProp( ) async {
    final results = await NetworkCommon().dio.get(APIConstants.SEARCH_WITH_PARAM,
        queryParameters: {"countryId": 1});
    if(results.statusCode==200){
      final suggestions = results.data;
      return suggestions
          .map<FieldProprtiresEntity>((json) => FieldProprtiresEntity.fromJson(json))
          .toList(growable: false);
    }
  }
}