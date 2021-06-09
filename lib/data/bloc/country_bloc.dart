import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:olx/data/remote/country_client.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cityModel.dart';
import 'package:olx/model/country_entity.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class CountryBloc implements Bloc {
  final _client = CountryClient();
  final _controller = BehaviorSubject<ApiResponse<List<CountryEntity>>>();

  Stream<ApiResponse<List<CountryEntity>>> get stream => _controller.stream;
  final _citycontroller = BehaviorSubject<ApiResponse<List<CityModel>>>();
  Stream<ApiResponse<List<CityModel>>> get cityStream => _citycontroller.stream;

  CountryBloc();



  void getCountryList() async {

     Stream.fromFuture(preferences.getCountryList())
         .onErrorResumeNext(Stream.fromFuture(_client.getCountryList())
         .doOnData((event) {preferences.saveAllCountry(event);}))
         .doOnListen(() {_controller.sink.add(ApiResponse<List<CountryEntity>>.loading("loading"));
     }).listen((event) {  _controller.sink.add(ApiResponse<List<CountryEntity>>.completed(event));
     },onError: (e){      _controller.sink.add(ApiResponse<List<CountryEntity>>.error(e.toString()));
     });


  }


  void getCityList() async {
    Stream.fromFuture(preferences.getCityList()).
    onErrorResume((error) => Stream.fromFuture(preferences.getCountryID()).
    flatMap((value) => Stream.fromFuture(_client.getCityList(int.parse(value))))
        .doOnData((event) {Stream.fromFuture(preferences.saveCities(event));}))
        .doOnListen(() {_citycontroller.sink.add(ApiResponse<List<CityModel>>.loading("loading") );})
        .listen((event) {_citycontroller.sink.add(ApiResponse<List<CityModel>>.completed(event));
    },onError: (e){      _citycontroller.sink.add(ApiResponse<List<CityModel>>.error(e.toString()));});
       


  }





  @override
  void dispose() {
    _controller.close();
  }
}
