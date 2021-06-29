 import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/detail_client.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/ads_detail.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:rxdart/rxdart.dart';

import '../shared_prefs.dart';

class DetailBloc extends Bloc{
  final _client = DetailAdsClient();
  final _controller = PublishSubject<ApiResponse<AdsDetail>>();
  final _sliderController = PublishSubject<List<AdvertismentImage>>();
  AdsDetail detail=null;
  final _viewController = PublishSubject<Counter>();
  Stream<Counter> get viewstream => _viewController.stream;
  Stream<List<AdvertismentImage>> get sliderStream => _sliderController.stream;

  Stream<ApiResponse<AdsDetail>> get stream => _controller.stream;

  void getAdsDetail(String adsID)async{
    _controller.sink.add(ApiResponse.loading("loading"));
    try {
      final results = await _client.getADsDetails(adsID);
       detail=results;
      _controller.sink.add(ApiResponse.completed(results));
    }catch(e){
      _controller.sink.add( ApiResponse.error(e.toString()));
    }
  }

  void viewAds() async {
    try {
      List<String> ids=await preferences.getViewedCommericalList();
      detail.ViewCount=detail.ViewCount==null?0:detail.ViewCount;
      if(ids!=null)
        for(String id in ids){
          if(id==detail.Id.toString()){
            _viewController.sink.add(Counter(detail.ViewCount,false));
            return;
          }
        }
      final results = await _client.viewAds(detail.Id.toString());
      if(results) {
        await preferences.saveViewCommericalList(detail.Id.toString());
        detail.ViewCount = detail.ViewCount + 1;
        _viewController.sink.add(Counter(detail.ViewCount, false));
      }else{
        _viewController.sink.add(Counter(detail.ViewCount,true));
      }
    }catch(e) {
      _viewController.sink.add(Counter(detail.ViewCount,true));
    }}




  @override
  void dispose() {
    _controller.close();
  }



  void GetImage(int index,String imageId) async {
    try {
      detail.AdvertismentImages[index].isLoading=true;
      final results = await _client.getImageAds(imageId);
      if(detail!=null) {

          detail.AdvertismentImages[index].isLoading=null;
          detail.AdvertismentImages[index].base64Image =
              results;

           }
      _controller.sink.add(ApiResponse.completed(detail));

    }catch(e) {

        detail.AdvertismentImages[index].isLoading=null;


    }}



  void GetImageSlider(int index,List<AdvertismentImage> images) async {
    try {
      detail.AdvertismentImages[index].isLoading=true;
      final results = await _client.getImageAds(images[index].Url);
      if(detail!=null) {

        images[index].isLoading=null;
        images[index].base64Image =
            results;

      }

      _sliderController.sink.add(images);

    }catch(e) {

      images[index].isLoading=null;
      _sliderController.sink.add(images);



    }}



}