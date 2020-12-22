import 'dart:async';

import 'package:olx/data/remote/addPostClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/edit_client.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/edit_field_property.dart';
import 'package:olx/model/user_info.dart';

class EditBloc implements Bloc{

  final _client = EditClient();
  final _controller = StreamController<EditFieldProperty>();
  final _addController = StreamController<ApiResponse<bool>>();

  Stream<EditFieldProperty> get stream => _controller.stream;
  Stream<ApiResponse<bool>> get addStream => _addController.stream;

  EditBloc();

  void getEditFieldsByCatID(String adsID) async {
    final results = await _client.getEditFieldByAddID(adsID);

    _controller.sink.add(results);
  }


  void editAdvertisment(AdsPostEntity obj) async {




    _addController.sink.add(ApiResponse.loading('loading'));
    try {
      UserInfo userInfo = await preferences.getUserInfo();
      obj.countryId = userInfo.countryId;
      obj.email=userInfo.email!=null?userInfo.email:"a@gmail.com";
      obj.userId=userInfo.id;
      obj.contactMe = 1;
      obj.isNew = true;
      obj.isFree = false;
      obj.userId = "";
      obj.arabicDescription = obj.englishDescription;

      final results = await _client.editAds(obj);
      _addController.sink.add(ApiResponse.completed(results));
    }catch(e){
      _addController.sink.add(ApiResponse.error(e));

    }


  }



  @override
  void dispose() {
    _controller.close();
_addController.close();
  }

  /*void getAddFieldsByCatID(int catId) async {
    final results = await _client.getPropertiesByCat(catId);

    _controller.sink.add(results);
  }}*/}