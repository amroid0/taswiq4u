
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
  final _controller = BehaviorSubject<List<CateogryEntity>>();
  final _subcontroller = BehaviorSubject<List<List<CateogryEntity>>>();
  final _cateogryStack =List<List<CateogryEntity>>();
  final _popupSubject=BehaviorSubject<ApiResponse<List<PopupAdsEntityList>>>();
  List<CateogryEntity> cateogyTitle=[];
  final _mainSliderSubject=BehaviorSubject<ApiResponse<List<PopupAdsEntityList>>>();

  final _imageNumberSubject=BehaviorSubject<int>.seeded(0);

  bool _hasMenu=false;

  Stream<List<CateogryEntity>> get stream => _controller.stream;
  List<List<CateogryEntity>> get categoryStack =>_cateogryStack;
  Stream<List<List<CateogryEntity>>> get subCatstream => _subcontroller.stream;
  Stream<ApiResponse<List<PopupAdsEntityList>>> get popupStream => _popupSubject.stream;
  Stream<ApiResponse<List<PopupAdsEntityList>>> get mainSliderStreaam => _mainSliderSubject.stream;
  Stream<int> get imageNumberStream => _imageNumberSubject.stream;
  CategoryBloc();

  void submitQuery(String query) async {
    cateogyTitle.clear();
    List<CateogryEntity> results = null ;//await preferences.getCateogryList();
    Stream.fromFuture(preferences.getCateogryList())
        .onErrorResumeNext(Stream.fromFuture(_client.getCateogryList()))
        .doOnData((event) { preferences.saveCateogryList(event);}).listen((event) {
        var res= event.where((element) => element.isActive).toList();
          _cateogryStack.clear();

      _cateogryStack.add(res);
      _controller.sink.add(res);
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




  void addCateogryToStack(CateogryEntity cateogry,[bool isDisplayed = true])  {
   if(_hasMenu && !isDisplayed){
     _hasMenu =false;
      cateogyTitle.removeLast();
     _cateogryStack.removeLast();
   }
    var res=cateogry.subCategories.where((element) => element.isActive).toList();
   if(cateogry.hasSub&&!isDisplayed){
     _hasMenu=cateogry.hasHorizontal;
   }
    cateogyTitle.add(cateogry);
   _cateogryStack.add(res);
   if(isDisplayed) {
     _controller.sink.add(res);
     _subcontroller.sink.add(_cateogryStack);
   }
  }
  void addSubCateogry(int level ,List<CateogryEntity> cateogry)  {
  var res=  cateogry.where((element) => element.isActive).toList();
    _cateogryStack.removeRange(level+1, _cateogryStack.length);
    _cateogryStack.add(res);
    _subcontroller.sink.add(_cateogryStack);

  }
  void removeCateogryFromStack()  {
    if(_hasMenu){
      _hasMenu =false;
      cateogyTitle.removeLast();
      _cateogryStack.removeLast();
    }
    cateogyTitle.removeLast();
    _cateogryStack.removeLast();
    _controller.sink.add(_cateogryStack[_cateogryStack.length-1]);
    _subcontroller.sink.add(_cateogryStack);


  }
  List<CateogryEntity>getCurrentCategory(){
 return   _cateogryStack.last;
  }
  bool hasHorizontlMenu(){
    return _hasMenu;
  }
  bool isStackIsEmpty(){
    return _cateogryStack.isEmpty;
  }

  @override
  void dispose() {
  /*  _controller.close();
    _subcontroller.close();
    _popupSubject.close();
  */}
}
