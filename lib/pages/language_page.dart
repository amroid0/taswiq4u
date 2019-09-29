import 'package:flutter/material.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/widget/fracation_sized_box.dart';

import 'country_page.dart';
import 'main_page.dart';

class ChooseLanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:<Widget>[ FractionallyAlignedSizedBox(
          bottomFactor: .6,
          child: Image.asset('images/logo.png'),
        ),

          FractionallyAlignedSizedBox(
topFactor:.5,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

              children: <Widget>[

               InkWell(
                onTap: () =>    Navigator.push(context,MaterialPageRoute(builder: (context) => CountryPage()))
                 ,
                child: new Container(
                  height: 60.0,
                  decoration: new BoxDecoration(
                    color: Colors.green,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(child: new Text('English', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                ),
              ),
              SizedBox(height: 10,),
               InkWell(
                onTap: () =>    Navigator.push(context,MaterialPageRoute(builder: (context) => MainScreen()))
                 ,
                child: new Container(
                  height: 60.0,
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(child: new Text('اللغه العربيه', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                ),
              ),















          ],),
            ),
          )




      ]) ,
    );
  }




}
