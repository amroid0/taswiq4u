import 'package:flutter/material.dart';
import 'package:olx/data/bloc/upload_image_bloc.dart';
import 'package:olx/pages/ImageUploaderListPage.dart';
import 'package:olx/pages/cateogry_dialog_page.dart';

import '../data/bloc/bloc_provider.dart';
import '../data/bloc/cateogry_bloc.dart';

class AddAdvertisment extends StatefulWidget {
  @override
  _AddAdvertismentState createState() => _AddAdvertismentState();
}

class _AddAdvertismentState extends State<AddAdvertisment> {
  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_){_showDialog();});
  }
  _showDialog() async{
    await showDialog<String>(
      context: context,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new Text('Select Cateogry'),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          content:  SingleChildScrollView(
            child:  Material(
              child:  BlocProvider(
                  bloc: CategoryBloc(),child:CategoryListDialog())
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          bloc: UploadImageBloc(),child:ImageInput()),
    );
  }
}
