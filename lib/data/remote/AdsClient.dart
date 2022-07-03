import 'dart:convert';

import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/ads_params.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/model/filter_response.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:olx/model/favroite_entity.dart';

class AdsClient{

  Future<AdsEntity> getCateogryList(FilterParamsEntity params, int orderby,int page) async {
    final results = await NetworkCommon().dio.post(APIConstants.SEARCH_WITH_PARAM,
        data:  jsonEncode(params),queryParameters: {"orderBy":orderby,"Page":page,"Size":20}

        );
    if (results.statusCode == 200) {
    return  AdsEntity.fromJson(results.data);
  }
  }


  Future<AdsEntity> searchWithKey(String query,int countId, int orderby) async {
    final results = await NetworkCommon().dio.post(APIConstants.SEARCH_KEY,
        queryParameters: {"orderBy":orderby,"key":query,"countryId":countId}
    );
    if (results.statusCode == 200) {
      return  AdsEntity.fromJson(results.data);
    }
  }

  Future<List<PopupAdsEntityList>> getPopupAds() async {
    final results = await NetworkCommon().dio.get(APIConstants.POPUP_ADS+"${await preferences.getCountryID()}"
    );
    if (results.statusCode == 200) {
      return results.data
          .map<PopupAdsEntityList>((json) => PopupAdsEntityList.fromJson(json))
          .toList(growable: false);
    }
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

  Future<List<AdsModel>> getMyAdsList( int page) async {
    final results = await NetworkCommon().dio.get(APIConstants.MY_ADS);
    if (results.statusCode == 200) {
      return results.data
          .map<AdsModel>((json) => AdsModel.fromJson(json))
          .toList(growable: false);
    }
  }

  Future<String> getImageAds(String imageName) async {
    final results = await NetworkCommon().dio.post(APIConstants.GET_IMAGE,
        data: {"ImageName":imageName}
    );
    if (results.statusCode == 200) {
      return  results.data.toString().split(',')[1];
    }
  }



  Future<List<PopupAdsEntityList>> getMainSliderAds() async {
    final results = await NetworkCommon().dio.get(APIConstants.MAIN_SLIDER_ADS+"${await preferences.getCountryID()}"
    );
    if (results.statusCode == 200) {
      return results.data
          .map<PopupAdsEntityList>((json) => PopupAdsEntityList.fromJson(json))
          .toList(growable: false);
    }
  }


  Future<bool>deleteAds(String id)async{
    final result=await NetworkCommon().dio.post(APIConstants.DELETE_ADS,queryParameters: {"id":id});
    if(result.statusCode==200){
      return true;
    }

  }


}