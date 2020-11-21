import 'dart:async';

import 'package:olx/data/remote/country_client.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/country_entity.dart';

import 'bloc.dart';

class CountryBloc implements Bloc {
  final _client = CountryClient();
  final _controller = StreamController<ApiResponse<List<CountryEntity>>>();

  Stream<ApiResponse<List<CountryEntity>>> get stream => _controller.stream;
  CountryBloc();



  void getCountryList() async {
    _controller.sink.add(ApiResponse<List<CountryEntity>>.loading("loading"));
    try{
      final result=await _client.getCountryList();
      _controller.sink.add(ApiResponse<List<CountryEntity>>.completed(result));

    }catch(e){
      _controller.sink.add(ApiResponse<List<CountryEntity>>.error(e.toString()));
    }



  }




  @override
  void dispose() {
    _controller.close();
  }
}
