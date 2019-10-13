import 'package:olx/model/StateEnum.dart';

class UploadedImage extends ImageListItem{
  String localPath;
  String remoteUrl;
  StateEnum state;

  UploadedImage({ this.localPath, this.remoteUrl, this.state});


}
class AddImage extends ImageListItem{


}
abstract class ImageListItem {
  int id;
}
