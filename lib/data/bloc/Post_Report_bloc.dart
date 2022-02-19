import 'dart:async';

import 'package:olx/data/remote/addPostClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/addReportClient.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/Post_Report_entity.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/user_info.dart';

class AdsReportBloc implements Bloc{

  final _client = addRepoertClient();
  final _addController = StreamController<ApiResponse<bool>>();

  Stream<ApiResponse<bool>> get addStream => _addController.stream;

  AdsReportBloc();


  void adsReport(PostReport obj) async {
    _addController.sink.add(ApiResponse.loading('loading'));
    try {
      UserInfo userInfo = await preferences.getUserInfo();
      obj.countryId = userInfo.countryId;
      obj.adId=obj.adId;
      obj.id=1;
      obj.reason=obj.reason;
      obj.message=obj.message;


      final results = await _client.PostNewReport(obj);
      _addController.sink.add(ApiResponse.completed(results));
    }catch(e){
      _addController.sink.add(ApiResponse.error(e.toString()));

    }

  }



  @override
  void dispose() {
    _addController.close();
  }
}