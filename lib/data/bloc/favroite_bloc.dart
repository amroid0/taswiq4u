import 'dart:async';

import 'package:olx/data/remote/AdsClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/favroite_client.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/ads_params.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:olx/model/favroite_entity.dart';


class FavroiteBloc implements Bloc {
  final _client = FavroiteClient();
  final _controller = BehaviorSubject<ApiResponse<FavoriteModel>>();
  final _favoriteStatecontroller = BehaviorSubject<ApiResponse<bool>>();

  Stream<ApiResponse<FavoriteModel>> get stream => _controller.stream;
  Stream<ApiResponse<bool>> get stateStream => _favoriteStatecontroller.stream;
  FavroiteBloc();

  void getFavroite(int page) async {
    _controller.sink.add(ApiResponse.loading('loading'));
    try {
        final results = await _client.getFavroiyeList(1);
      _controller.sink.add(ApiResponse.completed(results));

    }catch(e) {
      _controller.sink.add(ApiResponse.error(e.toString()));
    }}




  void changeFavoriteState(bool isFavorite,int? adsId) async {
    _favoriteStatecontroller.sink.add(ApiResponse.loading('loading'));
    try {
      final results = await _client.changeFavroiteState(isFavorite,adsId);
      _favoriteStatecontroller.sink.add(ApiResponse.completed(results));

    }catch(e) {
      _favoriteStatecontroller.sink.add(ApiResponse.error(e.toString()));
    }}



  @override
  void dispose() {
    _controller.close();
  }
}