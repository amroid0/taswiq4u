import 'dart:async';

import 'package:olx/data/AdsClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/model/ads_entity.dart';

class AdsBloc implements Bloc {
  final _client = AdsClient();
  final _controller = StreamController<AdsEntity>();

  Stream<AdsEntity> get stream => _controller.stream;
  AdsBloc();

  void submitQuery(int orderby) async {
    _controller.sink.add(null);
    final results = await _client.getCateogryList(orderby);
    _controller.sink.add(results);
  }



  @override
  void dispose() {
    _controller.close();
  }
}