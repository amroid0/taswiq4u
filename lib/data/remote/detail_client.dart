import 'package:olx/model/ads_detail.dart';
import 'package:olx/utils/Constants.dart';

import '../shared_prefs.dart';
import 'NetworkCommon.dart';

class DetailAdsClient{
  Future<AdsDetail>getADsDetails(String adsID)async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.DETAIL_API,
        queryParameters: {"adId": adsID});
    if(results.statusCode==200){
      final suggestions = results.data;
      return AdsDetail.fromJson(suggestions);
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


  Future<bool>viewAds(String adsID)async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.VIEW_ADS_API+adsID);
    if(results.statusCode==200){
      return true;
    }

  }

  Future<bool>deleteAds(String id)async{
    final result=await NetworkCommon().dio.post(APIConstants.DELETE_ADS,queryParameters: {"id":id});
        if(result.statusCode==200){
          return true;
        }

  }



  Future<bool>distinctAds(String id)async{
    final result=await NetworkCommon().dio.post(APIConstants.DISTINCT_ADS,queryParameters: {"adId":id});
    if(result.statusCode==200&&!(result.data["result"] as String).toLowerCase().contains("NotAllowed".toLowerCase())){
      return true;
    }else{
      return false;
    }


  }



}