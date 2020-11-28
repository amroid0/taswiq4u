
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/offfer_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';


import '../shared_prefs.dart';
import 'NetworkCommon.dart';

class OfferClient{


  Future<List<PopupAdsEntityList>> getOfferList(String catID,String  countryID) async {
    final results = await NetworkCommon()
        .dio.get(APIConstants.OFFER_ADS+countryID+"/"+ catID);
    if(results.statusCode==200){
      return results.data
          .map<PopupAdsEntityList>((json) => PopupAdsEntityList.fromJson(json))
          .toList(growable: false);    }
  }



  Future<bool>LikeAds(String adsID)async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.LIKE_ADS_API+adsID);
    if(results.statusCode==200){
      return true;
    }

  }

  Future<bool>viewAds(String adsID)async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.VIEW_ADS_API+adsID);
    if(results.statusCode==200){
      return true;
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

  Future<List<CateogryEntity>> getCateogryList( ) async {
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.CATEOGRY_ADS,
        queryParameters: {"countryId": await preferences.getCountryID(),"iscom":true});
    if(results.statusCode==200){
      final suggestions = results.data;
      List<CateogryEntity> list= suggestions
          .map<CateogryEntity>((json) => CateogryEntity.fromJson(json))
          .toList(growable: false);
      preferences.saveCateogryList(list);
      return list;
    }else{
      new CateogryEntity(name: "");
    }
  }


}