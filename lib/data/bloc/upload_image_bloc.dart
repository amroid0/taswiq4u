import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:olx/data/remote/AdsCateogryClient.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/model/StateEnum.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/upload_image_entity.dart';

import '../remote/UploadImageClient.dart';

class UploadImageBloc implements Bloc {
  final _client = UploadImageClient();
  final _controller = StreamController<List<ImageListItem>>();
   final _ImageList=List<ImageListItem>.empty();

  Stream<List<ImageListItem>> get stream => _controller.stream;
  List<ImageListItem> get getUploadImageList => _ImageList;

  UploadImageBloc(){
    _ImageList.add(AddImage());
    _controller.sink.add(_ImageList);
  }
  void uploadImage(List<int> path) async {
    var image=UploadedImage();
    image.id=_ImageList.length;
    image.localPath=path;
    image.state=StateEnum.LOADING;
    _ImageList.add(image);
    _controller.sink.add(_ImageList);
    final results = await _client.uploadAdsImage(path, image.id);
    if(results.id!<_ImageList.length){
    _ImageList[results.id!]=results;
    _controller.sink.add(_ImageList);
    }
  }

  void GetImage(int index,String imageId) async {
    try {
      final results = await _client.getImageAds(imageId);
      (_ImageList[index] as UploadedImage).base64Image = results;
      _controller.sink.add(_ImageList);
    }catch(e) {



    }}

  void addListImage(List<AdvertismentImage> images) async {
    for(var adsPhoto in images) {
      var image = UploadedImage();
      image.id = _ImageList.length;
      image.remoteUrl = adsPhoto.Url;
      image.state = StateEnum.NORMAL;
      _ImageList.add(image);
    }
      _controller.sink.add(_ImageList);

  }


  void removeImage(int  removeditemIndex){
    _ImageList.removeAt(removeditemIndex);
    _controller.sink.add(_ImageList);

  }

  void retryUpload(int index)async{
    var image=_ImageList[index] as UploadedImage;
    image.state=StateEnum.LOADING;
    _ImageList[index]=image;
    _controller.sink.add(_ImageList);
    final results = await _client.uploadAdsImage(image.localPath!, image.id);
    if(index < _ImageList.length) {
      _ImageList[index] = results;
      _controller.sink.add(_ImageList);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
