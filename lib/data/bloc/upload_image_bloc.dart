import 'dart:async';

import 'package:olx/data/AdsCateogryClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/model/StateEnum.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/upload_image_entity.dart';

import '../UploadImageClient.dart';

class UploadImageBloc implements Bloc {
  final _client = UploadImageClient();
  final _controller = StreamController<List<ImageListItem>>();
  final _ImageList=List<ImageListItem>();

  Stream<List<ImageListItem>> get stream => _controller.stream;
  UploadImageBloc(){
    _ImageList.add(AddImage());
    _controller.sink.add(_ImageList);
  }
  void uploadImage(String path) async {
    var image=UploadedImage();
    image.id=_ImageList.length;
    image.localPath=path;
    image.state=StateEnum.LOADING;
    _ImageList.add(image);
    _controller.sink.add(_ImageList);
    final results = await _client.uploadAdsImage(path, image.id);
    _ImageList[results.id]=results;
    _controller.sink.add(_ImageList);
  }


  @override
  void dispose() {
    _controller.close();
  }
}
