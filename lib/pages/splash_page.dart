import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/bloc/splash_bloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/welcome_page.dart';

import 'main_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color gradientStart = Colors.black12; //Change start gradient color here
  Color gradientEnd = Colors.black12;
     SplashBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc=SplashBloc();
    _bloc.getDefaultData();
     }
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
    alignment: Alignment.bottomCenter,),
            StreamBuilder<ApiResponse>(
                stream: _bloc.stream,
                builder: (context,snapshot){
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Container();
                        break;
                      case Status.COMPLETED:
                        var val=snapshot.data as ApiResponse<bool>;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if(val.data){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => BlocProvider(bloc:LoginBloc(),child: MainScreen()))
                            );
                          }else{//
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => WelocmeScreen()),
                            );
                          }
                        });

                        break;
                      case Status.ERROR
                          :
    WidgetsBinding.instance.addPostFrameCallback((_) {

    Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => WelocmeScreen()),
                        );});                        break;
                    }
                  }
                  return Container();

            })

          ]

        ),
      ),

    );
  }

}
