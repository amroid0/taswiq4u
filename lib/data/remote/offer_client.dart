
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


}