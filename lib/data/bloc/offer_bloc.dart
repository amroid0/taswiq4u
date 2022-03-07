import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/offer_client.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/offfer_entity.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';


class OfferBloc extends Bloc{
  final _client = OfferClient();
  final _controller = StreamController<ApiResponse<List<PopupAdsEntityList>>>.broadcast();
  final _cateogryController = StreamController<List<CateogryEntity>>.broadcast();
  final _likeController = StreamController<Counter>.broadcast();
  final _viewController = StreamController<Counter>.broadcast();
  final _imageController = StreamController<String>.broadcast();
  List<PopupAdsEntityList>? commercialAds=null;
  Stream<ApiResponse<List<PopupAdsEntityList>>> get stream => _controller.stream;
  Stream<Counter> get Likestream => _likeController.stream;
  Stream<Counter> get viewstream => _viewController.stream;
  Stream<String> get Imagestream => _imageController.stream;
  Stream<List<CateogryEntity>> get categoryStream => _cateogryController.stream;



  void getOfferCategory(String query) async {
    List<CateogryEntity>? results = null ;//await preferences.getCateogryList();
    if(results==null||results.isEmpty)
      results = await _client.getCateogryList();
    var res= results!.where((element) => element.isActive!).toList();

    _cateogryController.sink.add(res);
  }


  /*void GetImage(String imageId,int index) async {
    if(commercialAds.list[index].base64Image!=null) {
      _controller.sink.add(ApiResponse.completed(commercialAds));
      return;
    }
    try {
      final results = await _client.getImageAds(commercialAds.list[index].imageId.toString());
      commercialAds.list[index].base64Image=results;
      _controller.sink.add(ApiResponse.completed(commercialAds));

    }catch(e) {

    }}*/

void getOfferLsit(String categoryID) async {
  _controller.sink.add(ApiResponse.loading('loading'));
  try {
    String? countryId=await preferences.getCountryID();
     commercialAds = await _client.getOfferList(categoryID,countryId!);
    _controller.sink.add(ApiResponse.completed(commercialAds));

  }catch(e) {
    _controller.sink.add(ApiResponse.error(e.toString()));
  }


}
  void likeAds(int? index,isClicked) async {
    try {

      if(isClicked){
        final results = await _client.LikeAds(commercialAds![index!].id.toString());
        if(results!=null) {
           preferences.saveLikedCommericalList(commercialAds![index].id.toString());
          commercialAds![index].likes = commercialAds![index].likes! + 1;
          _likeController.sink.add(Counter(commercialAds![index].likes, false));
        }else{
          _likeController.sink.add(Counter(commercialAds![index].likes,true));
        }}else{
        _likeController.sink.add(Counter(commercialAds![index!].likes,true));
      }
    }catch(e) {
      _likeController.sink.add(Counter(commercialAds![index!].likes,true));
    }}
  void likePopUpAds(PopupAdsEntityList? item,isClicked) async {
    try {

      if(isClicked){
        final results = await _client.LikeAds(item!.id.toString());
        if(results!=null) {
           preferences.saveLikedCommericalList(item.id.toString());
          item.likes = item.likes! + 1;
          _likeController.sink.add(Counter(item.likes, false));
        }else{
          _likeController.sink.add(Counter(item.likes,true));
        }}else{
        _likeController.sink.add(Counter(item!.likes,true));
      }
    }catch(e) {
      _likeController.sink.add(Counter(item!.likes,true));
    }}





  void viewAds(int index) async {
    try {
  /*    List<String> ids=await preferences.getViewedCommericalList();
      if(ids!=null)
        for(String id in ids){
          if(id==commercialAds[index].id.toString()){
            _viewController.sink.add(Counter(commercialAds[index].viewsCount,false));
            return;
          }
        }*/
      final results = await _client.viewAds(commercialAds![index].id.toString());
      if(results!=null) {
         preferences.saveViewCommericalList(commercialAds![index].id.toString());
        commercialAds![index].viewsCount = commercialAds![index].viewsCount! + 1;
        _viewController.sink.add(Counter(commercialAds![index].viewsCount, false));
      }else{
        _viewController.sink.add(Counter(commercialAds![index].viewsCount,true));
      }
    }catch(e) {
      _viewController.sink.add(Counter(commercialAds![index].viewsCount,true));
    }}




  @override
  void dispose() {/*
    _controller.close();
    _viewController.close();
    _likeController.close();
    _imageController.close();*/
  }

}