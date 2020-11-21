 import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/search_client.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/api_response_entity.dart';

class FilterBloc extends Bloc{
  FilterBloc(){}

   final _client = SearchClient();
  final _controller = StreamController<ApiResponse<FieldPropReponse>>();
  Stream<ApiResponse<FieldPropReponse>> get stream => _controller.stream;

  void getAddFieldsByCatID(String  catId) async {
     _controller.sink.add(ApiResponse.loading("loading"));
    try {
      final results = await _client.getFieldsFilters(catId);
      _controller.sink.add(ApiResponse.completed(results));
    }catch(e){
    _controller.sink.add( ApiResponse.error(e.toString()));
    }}

  @override
  void dispose() {
    // TODO: implement dispose
  }

  void applayFilter(AdsPostEntity adsPostEntity) {

  }

 }