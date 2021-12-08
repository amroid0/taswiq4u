import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/favroite_entity.dart';
import 'package:olx/utils/Constants.dart';

import '../shared_prefs.dart';

class FavroiteClient{
  Future<FavoriteModel> getFavroiyeList( int page) async {
    final results = await NetworkCommon().dio.get(APIConstants.FAVROITE_ADS,queryParameters: {"Size": 100});
    if (results.statusCode == 200) {
      return  FavoriteModel.fromJson(results.data);
    }
  }
  Future<bool> changeFavroiteState(bool isFavroite,int adsId) async{
    String url=APIConstants.ADD_FAVROITE;
    final results = await NetworkCommon().dio.get(url, queryParameters: {"adId": adsId});
    if(results.statusCode==200){
       return results.data as bool;
    }
    return false;
  }



}