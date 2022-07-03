import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/splash_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/api_response_entity.dart';

import 'country_page.dart';

class SplashScreen extends StatefulWidget {
  bool isFirst;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color gradientStart = Colors.black12; //Change start gradient color here
  Color gradientEnd = Colors.black12;
  SplashBloc _bloc;
  List<String> l;

  @override
  void initState() {
    super.initState();
    _bloc = SplashBloc();
    _bloc.getDefaultData();
    getisFirst();
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
          StreamBuilder<ApiResponse>(
              stream: _bloc.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return Container();
                      break;
                    case Status.COMPLETED:
                      var val = snapshot.data as ApiResponse<bool>;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (val.data && widget.isFirst == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CountryPage()));
                        } else if (val.data && widget.isFirst == false) {
                          //
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountryPage()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountryPage()),
                          );
                        }
                      });

                      break;
                    case Status.ERROR:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountryPage()),
                        );
                      });
                      break;
                  }
                }
                return Container();
              })
        ]),
      ),
    );
  }

  Future getisFirst() async {
    widget.isFirst = await preferences.getIsFirstTime();
    if (widget.isFirst == null) {
      widget.isFirst = true;
    } else {
      print("isFirst" + widget.isFirst.toString());
    }
  }
}
