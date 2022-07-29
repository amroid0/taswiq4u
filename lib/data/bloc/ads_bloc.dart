import 'dart:async';

import 'package:olx/data/remote/AdsClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/ads_params.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/filter_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:olx/model/favroite_entity.dart';

class AdsBloc implements Bloc {
  final _client = AdsClient();
  AdsEntity ads= AdsEntity();
  final _controller = BehaviorSubject<ApiResponse<AdsEntity>>();
  final _myAddController = BehaviorSubject<ApiResponse<List<AdsModel>>>();
  final _deleteStatecontroller = BehaviorSubject<ApiResponse<bool>>();
  final _featureStatecontroller = BehaviorSubject<ApiResponse<bool>>();
  Stream<ApiResponse<bool>> get deleteStateStream => _deleteStatecontroller.stream;
  Stream<ApiResponse<bool>> get featureStateStream => _featureStatecontroller.stream;
  Stream<ApiResponse<AdsEntity>> get stream => _controller.stream;
  Stream<ApiResponse<List<AdsModel>>> get myAdsstream => _myAddController.stream;
  AdsBloc();

  void submitQuery(FilterParamsEntity paramsEntity,int orderby,int page) async {
    if(page==1) {
      _controller.sink.add(ApiResponse.loading('loading'));
    }else{
      ads.isLoadMore=true;
      ads.advertisementList.add(null);
      _controller.sink.add(ApiResponse.completed(ads));

    }
    try {
      String countryId=await preferences.getCountryID();
//      AdsParams params=AdsParams( CategoryId:int.parse(catId),CityId: 1,CountryId: int.tryParse(countryId) );
      FilterParamsEntity entity=new FilterParamsEntity();
      entity.stateId=paramsEntity.cityId;
      entity.countryId=int.tryParse(countryId) ;
      entity.cityId=paramsEntity.cityId;
      entity.isNew=paramsEntity.isNew;
      entity.priceMax=paramsEntity.priceMax;
      entity.priceMin=paramsEntity.priceMin;
      entity.categoryId=paramsEntity.categoryId;

      if(paramsEntity.params!=null) {
        entity.params =[];
        for(var item in paramsEntity.params){
          if(item!=null){
            entity.params.add(item);
          }
        }
      }

      AdsEntity newAds = await _client.getCateogryList(entity,orderby,page);

        if(page==1){
          ads=newAds;
        }else {

          ads.advertisementList.removeLast();
            List<AdsModel> list = new List<AdsModel>();
            list.addAll(ads.advertisementList);
            list.addAll(newAds.advertisementList);
            List<CommercialAdsList>commerial= ads.commercialAdsList;
          ads=newAds;
          ads.advertisementList.clear();
          ads.advertisementList.addAll(list);
          ads.commercialAdsList.clear();
          ads.commercialAdsList.addAll(commerial);
          ads.isLoadMore=null;

        }
        _controller.sink.add(ApiResponse.completed(ads));

    }catch(e) {
       if(page==1)
      _controller.sink.add(ApiResponse.error(e.toString()));
     ads.isLoadMore=null;
    }}

    void refreshData(){
      _controller.sink.add(ApiResponse.completed(ads));
    }



  void searchWithKey(String query,int orderby) async {
    _controller.sink.add(ApiResponse.loading('loading'));
    try {
      String countryId=await preferences.getCountryID();
      ads = await _client.searchWithKey(query,int.parse(countryId),orderby);
      _controller.sink.add(ApiResponse.completed(ads));

    }catch(e) {
      _controller.sink.add(ApiResponse.error(e.toString()));
    }
  }


  void getMyAdsListe(int page) async {
    _myAddController.sink.add(ApiResponse.loading('loading'));
    try {
      final results = await _client.getMyAdsList(page);
      _myAddController.sink.add(ApiResponse.completed(results));

    }catch(e) {
      _myAddController.sink.add(ApiResponse.error(e.toString()));
    }}









/*
  void GetImage(String imageId,int index,bool isCommerical) async {
    try {
      if(isCommerical)ads.commercialAdsList[index].isLoading=true;
      else ads.advertisementList.list[index].AdvertismentImages[0].isLoading=true;
      final results = await _client.getImageAds(imageId);
      if(ads!=null) {
      if(isCommerical){
        ads.commercialAdsList[index].isLoading=null;
        ads.commercialAdsList[index].base64Image =
            results;
      }
        else {
        ads.advertisementList.list[index].AdvertismentImages[0].isLoading=null;
        ads.advertisementList.list[index].AdvertismentImages[0].base64Image =
            results;

        }   }
      _controller.sink.add(ApiResponse.completed(ads));

    }catch(e) {
      if(isCommerical){
        ads.commercialAdsList[index].isLoading=null;
      }
      else {
        ads.advertisementList.list[index].AdvertismentImages[0].isLoading=null;

      }
    }}
*/
  void deleteAds(String adsID)async{
    try{
      _deleteStatecontroller.sink.add(ApiResponse.loading("message"));
      final results = await _client.deleteAds(adsID);
      _deleteStatecontroller.sink.add(ApiResponse.completed(results));
    }catch(e){
      _deleteStatecontroller.sink.add( ApiResponse.error(e.toString()));

    }
  }
  void distinictAds(String adsID)async{
    try{
      _featureStatecontroller.sink.add(ApiResponse.loading("message"));
      final results = await _client.featuredAds(adsID);
      _featureStatecontroller.sink.add(ApiResponse.completed(results));
    }catch(e){
      _featureStatecontroller.sink.add( ApiResponse.error(e.toString()));

    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}