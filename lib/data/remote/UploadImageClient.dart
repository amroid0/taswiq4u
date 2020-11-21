import 'package:dio/dio.dart';
import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/model/StateEnum.dart';
import 'package:olx/model/upload_image_entity.dart';
import 'package:olx/utils/Constants.dart';

class UploadImageClient{
  Future<UploadedImage> uploadAdsImage(String imagePath,int id) async {
    try {
      final results = await NetworkCommon()
          .dio.post(APIConstants.IMAGE_UPLOAD,
          data: FormData.fromMap({
            "name": "wendux",
            "age": 25,
            "file": await MultipartFile.fromFile(
                imagePath, filename: "upload.png")
          })

      );
      var image = UploadedImage();
      image.remoteUrl = results.data["url"];
      image.id = id;
      image.localPath = imagePath;
      image.state = StateEnum.NORMAL;
      return image;

    }catch(e){
      var image = UploadedImage();
      image.id = id;
      image.localPath = imagePath;
      image.state = StateEnum.FAILED;
      return image;
    }
  }

  getImageAds(String imageId) {}

}