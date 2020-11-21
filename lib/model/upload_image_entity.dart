import 'package:olx/model/StateEnum.dart';

class UploadedImage extends ImageListItem{
  String localPath;
  String remoteUrl;
  StateEnum state;
  var base64Image;

  UploadedImage({ this.localPath, this.remoteUrl, this.state,this.base64Image});


}
class AddImage extends ImageListItem{


}
abstract class ImageListItem {
  int id;
}
