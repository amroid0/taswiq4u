import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/CommericalClient.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/ads_detail.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';

class CommericalBloc extends Bloc{
  final _client = CommericalClient();
  final _controller = StreamController<ApiResponse<CommercialAdsList>>();
  final _likeController = StreamController<Counter>();
  final _viewController = StreamController<Counter>();
  final _imageController = StreamController<String>();
  CommercialAdsList commercialAds=null;
  Stream<ApiResponse<CommercialAdsList>> get stream => _controller.stream;
  Stream<Counter> get Likestream => _likeController.stream;
  Stream<Counter> get viewstream => _viewController.stream;
  Stream<String> get Imagestream => _imageController.stream;

  void GetImage() async {
     if(commercialAds.base64Image!=null) {
       _imageController.sink.add(commercialAds.base64Image);
        return;
     }
    try {
      final results = await _client.getImageAds(commercialAds.ImageId.toString());
      commercialAds.base64Image=results;
      _imageController.sink.add(commercialAds.base64Image);

    }catch(e) {

    }}


  void likeAds(isClicked) async {
    try {
      List<String> ids=await preferences.getLikedCommericalList();
      if(ids!=null)
      for(String id in ids){
        if(id==commercialAds.Id.toString()){
          _likeController.sink.add(Counter(commercialAds.Likes,false));
           return;
        }
      }
     if(isClicked){
      final results = await _client.LikeAds(commercialAds.Id.toString());
      if(results) {
        await preferences.saveLikedCommericalList(commercialAds.Id.toString());
        commercialAds.Likes = commercialAds.Likes + 1;
        _likeController.sink.add(Counter(commercialAds.Likes, false));
      }else{
        _likeController.sink.add(Counter(commercialAds.Likes,true));
      }}else{
       _likeController.sink.add(Counter(commercialAds.Likes,true));
     }
    }catch(e) {
      _likeController.sink.add(Counter(commercialAds.Likes,true));
    }}


  void viewAds() async {
    try {
      List<String> ids=await preferences.getViewedCommericalList();
      if(ids!=null)
      for(String id in ids){
        if(id==commercialAds.Id.toString()){
          _viewController.sink.add(Counter(commercialAds.ViewsCount,false));
          return;
        }
      }
        final results = await _client.viewAds(commercialAds.Id.toString());
        if(results) {
          await preferences.saveViewCommericalList(commercialAds.Id.toString());
          commercialAds.ViewsCount = commercialAds.ViewsCount + 1;
          _viewController.sink.add(Counter(commercialAds.ViewsCount, false));
        }else{
          _viewController.sink.add(Counter(commercialAds.ViewsCount,true));
        }
    }catch(e) {
      _viewController.sink.add(Counter(commercialAds.ViewsCount,true));
    }}




  @override
  void dispose() {
    _controller.close();
    _viewController.close();
    _likeController.close();
    _imageController.close();
  }

  void setDefaultData(CommercialAdsList detailArgs) {
    commercialAds=detailArgs;
  }
  ApiResponse<CommercialAdsList>getDefaultData()
  {
    ApiResponse<CommercialAdsList> response=ApiResponse.completed(commercialAds);
    return response;
  }
}