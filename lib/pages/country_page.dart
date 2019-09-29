import 'package:flutter/material.dart';
import 'package:olx/pages/login_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
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

            Container(
              height: 100,
              child: Column(children: <Widget>[

                Stack(

                  children: <Widget>[

                    Positioned(
                      left: 0.0,
                      right: 0.0,

                      child: InkWell(
                        onTap: () =>    Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage())),
                        child: Container(
                          margin: EdgeInsets.only(right: 60,left: 10),
                          height: 60,
                          decoration: new BoxDecoration(
                            color: Colors.black38,
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 30,
                        child: planetThumbnail
                    )
                  ],
                ),Stack(
                  children: <Widget>[

                    Positioned(
                      left: 0.0,
                      right: 0.0,

                      child: InkWell(
                          onTap: () =>    Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage())),

                          child: Container(

                          margin: EdgeInsets.only(right: 60,left: 10),
                          height: 60,
                          decoration: new BoxDecoration(
                            color: Colors.black38,
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 30,
                        child: planetThumbnail
                    )
                  ],
                )

              ],),
            )




          ]) ,
    );
  }





}
