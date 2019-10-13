import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/upload_image_bloc.dart';
import 'package:olx/model/StateEnum.dart';
import 'package:olx/model/upload_image_entity.dart';
import 'package:olx/utils/Theme.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInput();
  }
}
class _ImageInput extends State<ImageInput> {
  // To store the file provided by the image_picker

var _bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = BlocProvider.of<UploadImageBloc>(context);
  }
  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    _bloc.uploadImage(image.path);
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
   return Expanded(
      child: StreamBuilder<List<ImageListItem>>(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            return _buildImageList(snapshot.data);
          }
      ),
    );


  }

  Widget _buildImageList(List<ImageListItem> items) {

   return ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: items.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = items[index];

        if (item is AddImage) {
          return GestureDetector(
              child: Container(
                  width:100,
                  height: 60,

              child: Icon(Icons.search,color: Colors.black,),
              ),onTap:(){
            _openImagePickerModal(context);
          }
          );
        } else if (item is UploadedImage) {

          return Stack(
            children: <Widget>[
              Container(
                width:100,
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.appBackground,
                ),
                child: Image.file(
                  File(item.localPath),
                  fit: BoxFit.fill,
                ),
              ),
            ],
          );
        }
      },
    );

  }
}
