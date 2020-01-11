import 'package:flutter/material.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/pages/login_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/fracation_sized_box.dart';

class CountryPage extends StatelessWidget {

  final planetThumbnail =  Container(

   child: new Image(
     image: new AssetImage("images/egypt.png"),
     height: 50.0,
     width: 50.0,
    ),
  );
  final planetCard = new Container(
    height: 60.0,
          margin: new EdgeInsets.only(right: 46.0,left: 8),
   decoration: new BoxDecoration(
     color:  Colors.black12,
     shape: BoxShape.rectangle,
     borderRadius: new BorderRadius.circular(8.0),

    ),
  );
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
                      onTap: () {
                        /*Navigator.push(context,MaterialPageRoute(builder: (context) => CountryPage()))*/
                        preferences.saveCountryID("1");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ParentAuthPage()));},
                      child: new Container(
                        height: 60.0,
                        decoration: new BoxDecoration(
                          color: Colors.green,
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Center(child: new Text(allTranslations.text("page.egypt"), style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        preferences.saveCountryID("2");

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ParentAuthPage()));
                      }
                      ,
                      child: new Container(
                        height: 60.0,
                        decoration: new BoxDecoration(
                          color: Colors.black,
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Center(child: new Text(allTranslations.text("page.kuwait"), style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                      ),
                    ),















                  ],),
              ),
            )




          ]) ,
    );
  }





}
