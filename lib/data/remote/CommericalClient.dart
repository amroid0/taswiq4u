import 'package:olx/model/ads_entity.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class CommericalClient {
  Future<CommercialAdsList?>getADsDetails(String adsID)async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.DETAIL_API+adsID);
    if(results.statusCode==200){
      final suggestions = results.data;
      return CommercialAdsList.fromJson(suggestions);
    }

  }

  Future<bool?>LikeAds(String adsID)async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.LIKE_ADS_API+adsID);
    if(results.statusCode==200){
      return true;
    }

  }

  Future<bool?>viewAds(String adsID)async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.VIEW_ADS_API+adsID);
    if(results.statusCode==200){
      return true;
    }

  }


  Future<String?> getImageAds(String imageName) async {
    final results = await NetworkCommon().dio.post(APIConstants.GET_IMAGE,
        data: {"ImageName":imageName}
    );
    if (results.statusCode == 200) {
      return  results.data.toString().split(',')[1];
    }
  }

}