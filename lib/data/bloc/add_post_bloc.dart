import 'dart:async';

import 'package:olx/data/remote/addPostClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/ads_post_entity.dart';

class AddPostBloc implements Bloc{

  final _client = addPostClient();
  final _controller = StreamController<FieldPropReponse>();
  final _addController = StreamController<bool>();

  Stream<FieldPropReponse> get stream => _controller.stream;
  Stream<bool> get addStream => _addController.stream;

  AddPostBloc();

  void getAddFieldsByCatID(int catId) async {
    final results = await _client.getPropertiesByCat(catId);
    _controller.sink.add(results);
  }


  void postAds(AdsPostEntity obj) async {
    final results = await _client.PostNewAds(obj);
    _addController.sink.add(results);
  }



  @override
  void dispose() {
    _controller.close();
  }
}