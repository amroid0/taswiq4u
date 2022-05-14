import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:olx/model/StateEnum.dart';

class UploadedImage extends ImageListItem{
  List<int> localPath;
  String remoteUrl;
  StateEnum state;
  var base64Image;

  UploadedImage({ this.localPath, this.remoteUrl, this.state,this.base64Image});


}
class AddImage extends ImageListItem{


}
abstract class ImageListItem {
  int id;
  int uplodedID;
}
