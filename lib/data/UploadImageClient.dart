import 'package:dio/dio.dart';
import 'package:olx/data/NetworkCommon.dart';
import 'package:olx/model/upload_image_entity.dart';
import 'package:olx/utils/Constants.dart';

class UploadImageClient{
  final String BASE_PATH="ImageUpload/AddAdvertismentImage";
  Future<UploadedImage> uploadAdsImage(String imagePath,int id) async {
    final results = await NetworkCommon()
        .dio.post("http://api.wdmsystems.com/Api/" + BASE_PATH,
        data:  FormData.fromMap({
          "name": "wendux",
          "age": 25,
          "file": await MultipartFile.fromFile(imagePath,filename: "upload.png")
        })

    );
    var image=UploadedImage();
     image.remoteUrl=results.data;
     image.id=id;
     return image;
  }

}