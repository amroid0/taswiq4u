
import 'dart:async';

import 'package:olx/data/AdsCateogryClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/model/cateogry_entity.dart';


class CategoryBloc implements Bloc {
  final _client = AdsCategoryClient();
  final _controller = StreamController<List<CateogryEntity>>();
  final _cateogryStack =List<List<CateogryEntity>>();

  Stream<List<CateogryEntity>> get stream => _controller.stream;
  CategoryBloc();

  void submitQuery(String query) async {
    final results = await _client.getCateogryList();
    _cateogryStack.add(results);
    _controller.sink.add(results);
  }

  void addCateogryToStack(List<CateogryEntity> cateogry)  {
    _cateogryStack.add(cateogry);
    _controller.sink.add(cateogry);
  }
  void removeCateogryFromStack()  {
    _cateogryStack.removeLast();
    _controller.sink.add(_cateogryStack[_cateogryStack.length-1]);
  }
  bool isStackIsEmpty(){
    return _cateogryStack.isEmpty;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
