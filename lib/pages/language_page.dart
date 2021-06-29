import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/languge_bloc.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/welcome_page.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/fracation_sized_box.dart';

import 'country_page.dart';
import 'main_page.dart';

class ChooseLanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children:<Widget>[ FractionallyAlignedSizedBox(
          bottomFactor: .6,
          child: Image.asset('images/logo.png'),
        ),

          FractionallyAlignedSizedBox(
topFactor:.5,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SlideInUp(
                child: Column(

                children: <Widget>[

                 InkWell(
                  onTap: () {
                    BlocProvider.of<TranslationsBloc>(context).setNewLanguage(
                        "en");
                    /*Navigator.push(context,MaterialPageRoute(builder: (context) => CountryPage()))*/

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CountryPage()));},
                  child: new Container(
                    height: 60.0,
                    decoration: new BoxDecoration(
                      color: Colors.green,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: new Center(child: new Text(allTranslations.text("page.lang"), style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                  ),
                ),
                SizedBox(height: 10,),
                 InkWell(
                  onTap: () {
                    BlocProvider.of<TranslationsBloc>(context).setNewLanguage(
                        "ar");

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WelocmeScreen()));
                  }
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
            ),
          )




      ]) ,
    );
  }




}
