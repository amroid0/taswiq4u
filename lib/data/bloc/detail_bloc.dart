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
  final _deleteStatecontroller = BehaviorSubject<ApiResponse<bool>>();
  final _distnctStatecontroller = BehaviorSubject<ApiResponse<bool>>();

  AdsDetail detail=null;
  final _viewController = PublishSubject<Counter>();
  final _translateController = BehaviorSubject<bool>();
  Stream<ApiResponse<bool>> get deleteStateStream => _deleteStatecontroller.stream;
  Stream<ApiResponse<bool>> get distnictStateStream => _distnctStatecontroller.stream;

  Stream<bool> get translatestream => _translateController.stream;

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
      _distnctStatecontroller.sink.add(ApiResponse.loading("message"));
      final results = await _client.distinctAds(adsID);
      if(results)
      _distnctStatecontroller.sink.add(ApiResponse.completed(results));
      else
        _distnctStatecontroller.sink.add( ApiResponse.error(""));

    }catch(e){
      _distnctStatecontroller.sink.add( ApiResponse.error(e.toString()));

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

  void translateAds() {
    bool istranslate=_translateController.value??false;
    _translateController.sink.add(!istranslate);

  }



}