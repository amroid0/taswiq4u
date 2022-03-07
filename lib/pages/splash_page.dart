import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/splash_bloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/pages/welcome_page.dart';

import 'language_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color gradientStart = Colors.black12; //Change start gradient color here
  Color gradientEnd = Colors.black12;
  late SplashBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SplashBloc();
    _bloc.stream.listen((event) {
      switch (event.status) {
        case Status.LOADING:
          break;
        case Status.COMPLETED:
          var val = event.data! ;
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (val) {
              print("naviagte to lang page");

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseLanguagePage()));
            } else {
              //
              print("naviagte to Welcome page");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelocmeScreen()),
              );
            }
          });

          break;
        case Status.ERROR:
          print("naviagte to lang page");
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChooseLanguagePage()),
            );
          });
          break;
      }
    });

    _bloc.getDefaultData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Color(0xecececec),
              Color(0xFFFFFFff),
              Color(0xecececec),
            ],
                tileMode: TileMode.clamp,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Stack(children: <Widget>[
          BounceInDown(
            child: Align(
              child: Image.asset('images/logo.png'),
              alignment: Alignment.center,
            ),
          ),
          Align(
            child: Container(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                )),
            alignment: Alignment.bottomCenter,
          ),
        ]),
      ),
    );
  }
}
