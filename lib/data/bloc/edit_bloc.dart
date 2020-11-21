import 'dart:async';

import 'package:olx/data/remote/addPostClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/edit_client.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/api_response_entity.dart';

class EditBloc implements Bloc{

  final _client = EditClient();
  final _controller = StreamController<FieldPropReponse>();
  final _addController = StreamController<ApiResponse<bool>>();

  Stream<FieldPropReponse> get stream => _controller.stream;
  Stream<ApiResponse<bool>> get addStream => _addController.stream;

  EditBloc();

  void getEditFieldsByCatID(String adsID) async {
    final results = await _client.getEditFieldByAddID(adsID);

    _controller.sink.add(results);
  }


  void editAdvertisment(AdsPostEntity obj) async {




    _addController.sink.add(ApiResponse.loading('loading'));
    try {
      String countryID = await preferences.getCountryID();
      obj.countryId = int.tryParse(countryID);
      obj.cityId = 1;
      obj.stateId = 1;
      obj.contactMe = 1;
      obj.isNew = true;
      obj.isFree = false;
      obj.userId = "";
      obj.arabicDescription = obj.englishDescription;
      obj.advertismentSpecification = [];
    // TODO: remove  obj.advertismentSpecification = [];

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

  void getAddFieldsByCatID(int catId) async {
    final results = await _client.getPropertiesByCat(catId);

    _controller.sink.add(results);
  }}