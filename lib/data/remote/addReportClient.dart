

import 'dart:convert';

import 'package:olx/model/Post_Report_entity.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class addRepoertClient{
 // Future <bool> PostNewReport (AdsReportEntity reuqestObject )
  Future<bool> PostNewReport( PostReport reuqestObject) async {
    try{
      final results = await NetworkCommon().dio.post(APIConstants.Repoert_Ads_API,
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