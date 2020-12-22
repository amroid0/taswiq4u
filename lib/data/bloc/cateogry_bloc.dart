
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:olx/data/remote/AdsCateogryClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/AdsClient.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:rxdart/rxdart.dart';

import '../shared_prefs.dart';


class CategoryBloc implements Bloc {
  final _client = AdsCategoryClient();
  final _AdsCleint= AdsClient();
  final _controller = StreamController<List<CateogryEntity>>();
  final _subcontroller = StreamController<List<List<CateogryEntity>>>();
  final _cateogryStack =List<List<CateogryEntity>>();
  final _popupSubject=BehaviorSubject<ApiResponse<List<PopupAdsEntityList>>>();

  final _mainSliderSubject=BehaviorSubject<ApiResponse<List<PopupAdsEntityList>>>();

  final _imageNumberSubject=BehaviorSubject<int>.seeded(0);

  Stream<List<CateogryEntity>> get stream => _controller.stream;
  Stream<List<List<CateogryEntity>>> get subCatstream => _subcontroller.stream;
  Stream<ApiResponse<List<PopupAdsEntityList>>> get popupStream => _popupSubject.stream;
  Stream<ApiResponse<List<PopupAdsEntityList>>> get mainSliderStreaam => _mainSliderSubject.stream;
  Stream<int> get imageNumberStream => _imageNumberSubject.stream;
  CategoryBloc();

  void submitQuery(String query) async {
    List<CateogryEntity> results = null ;//await preferences.getCateogryList();
    Stream.fromFuture(preferences.getCateogryList())
        .onErrorResumeNext(Stream.fromFuture(_client.getCateogryList()))
        .doOnData((event) { preferences.saveCateogryList(event);}).listen((event) {
          _cateogryStack.clear();
      _cateogryStack.add(event);
      _controller.sink.add(event);
      _subcontroller.sink.add(_cateogryStack);
    },onError: (){});



  }
 void updateImageSliderNumber(int inedx){
    _imageNumberSubject.sink.add(inedx);
 }

  void getPopupAds() async {
   _popupSubject.sink.add(ApiResponse<List<PopupAdsEntityList>>.loading("loading"));
   try{
     final result=await _AdsCleint.getPopupAds();
     _popupSubject.sink.add(ApiResponse<List<PopupAdsEntityList>>.completed(result));

   }catch(e){
     _popupSubject.sink.add(ApiResponse<List<PopupAdsEntityList>>.error(e.toString()));
   }



  }




  void getMainSliderAds() async {
    _mainSliderSubject.sink.add(ApiResponse<List<PopupAdsEntityList>>.loading("loading"));
    try{
      final result=await _AdsCleint.getMainSliderAds();
      _mainSliderSubject.sink.add(ApiResponse<List<PopupAdsEntityList>>.completed(result));

    }catch(e){
      _mainSliderSubject.sink.add(ApiResponse<List<PopupAdsEntityList>>.error(e.toString()));
    }



  }




  void addCateogryToStack(List<CateogryEntity> cateogry)  {
    _cateogryStack.add(cateogry);
    _controller.sink.add(cateogry);
    _subcontroller.sink.add(_cateogryStack);

  }
  void addSubCateogry(int level ,List<CateogryEntity> cateogry)  {
     _cateogryStack.removeRange(level+1, _cateogryStack.length);
    _cateogryStack.add(cateogry);
    _subcontroller.sink.add(_cateogryStack);

  }
  void removeCateogryFromStack()  {
    _cateogryStack.removeLast();
    _controller.sink.add(_cateogryStack[_cateogryStack.length-1]);
    _subcontroller.sink.add(_cateogryStack);


  }
  List<CateogryEntity>getCurrentCategory(){
 return   _cateogryStack.last;
  }
  bool isStackIsEmpty(){
    return _cateogryStack.isEmpty;
  }

  @override
  void dispose() {
    _controller.close();
    _subcontroller.close();
    _popupSubject.close();
  }
}
