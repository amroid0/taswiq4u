import 'dart:convert';

import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/utils/Constants.dart';

class addPostClient{
  Future<FieldPropReponse> getPropertiesByCat( int catId) async {
    try{
    final results = await NetworkCommon()
        .dio.get(APIConstants.FIELDS_ADD_ADS+catId.toString(),
    );
    if(results.statusCode==200){
      final suggestions = results.data;
      var list= suggestions
          .map<FieldProprtiresEntity>((json) => FieldProprtiresEntity.fromJson(json))
          .toList(growable: false);
      return FieldPropReponse(list, true);
    }else{
      return FieldPropReponse(List(), false);

    }
  }catch(e){
      return FieldPropReponse(List(), false);
    }
  }

  Future<bool> PostNewAds( AdsPostEntity reuqestObject) async {
    try{
      final results = await NetworkCommon().dio.post(APIConstants.ADD_ADS,
     data: jsonEncode(reuqestObject)

      );
      if(results.statusCode==200){
        return true;
      }else{
        return false;

      }
    }catch(e){
      return false;
    }
  }

}