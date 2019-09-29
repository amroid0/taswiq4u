import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color gradientStart = Colors.black12; //Change start gradient color here
  Color gradientEnd = Colors.black12;


  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelocmeScreen()),
        ));  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Color(0xecececec),
            Color(0xFFFFFFff),
            Color(0xecececec),

        ],
            tileMode: TileMode.clamp
        ,
          begin: Alignment.topLeft,
            end: Alignment.bottomRight
        )),
        child: Stack(
          children:<Widget>[
            Align( child:Image.asset('images/logo.png'),
            alignment: Alignment.center,),
        Align( child:Container( padding: EdgeInsets.only(bottom: 10),child: LinearProgressIndicator(backgroundColor: Colors.green,)),
    alignment: Alignment.bottomCenter,)
          ]

        ),
      ),
      
    );
  }

}
