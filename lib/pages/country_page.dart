
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/country_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/pages/login_page.dart';
import 'package:olx/pages/main_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/fracation_sized_box.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {


  CountryBloc bloc;
  @override
  void initState() {
    preferences.clearCity();
    // TODO: implement initState
    bloc=new CountryBloc();
    bloc.getCountryList();
    super.initState();
  }



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
                    child: StreamBuilder<ApiResponse<List<CountryEntity>>>(
                      stream: bloc.stream,
                      builder: (context,snapshot){
                        if(snapshot.data!=null){
                          switch(snapshot.data.status){
                            case Status.LOADING:
                              return new Center(
                                child: new CircularProgressIndicator(
                                  backgroundColor: Colors.deepOrangeAccent,
                                  strokeWidth: 5.0,
                                ),
                              );
                              break;
                            case Status.COMPLETED:
                            // TODO: Handle this case.
                            List<CountryEntity> list=snapshot.data.data;
                            return SlideInUp(
                              child: ListView.separated(
                                itemCount: list.length,
                                  separatorBuilder: (ctx,inde)=>SizedBox(height: 16,),
                                  itemBuilder: (BuildContext context,int index){
                                return
                                  InkWell(
                                    onTap: () {
                                      /*Navigator.push(context,MaterialPageRoute(builder: (context) => CountryPage()))*/
                                      preferences.saveCountryID(list[index].countryId.toString());
                                      print("counnn"+list[index].countryId.toString());
                                      preferences.saveCountry(list[index]);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) =>  MainScreen()));},
                                    child:
                                     Stack(
                                          children:[
                                     Container(
                                     margin:  const EdgeInsets.symmetric(vertical: 0, horizontal: 25.0),
                                      height: 60.0,
                                      decoration: new BoxDecoration(
                                        color: Color(0xffF2F4F6),
                                        borderRadius: new BorderRadius.circular(10.0),
                                      ),),
                                        Positioned.directional(
                                          textDirection: allTranslations.isEnglish?TextDirection.ltr:TextDirection.rtl,
                                          start:0,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4,vertical: 0),
                                            child: Image.asset(
                                              list[index].countryId==1?'images/egyptflag.png':'images/kuwaitflag.png',
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                         Align(alignment: Alignment.bottomCenter,child: Text(allTranslations.isEnglish?list[index].englishDescription.toString():list[index].arabicDescription, style: new TextStyle(fontSize: 20.0,fontWeight:FontWeight.w600),))
                                  ]
                                  ),

                                  );
                              }),
                            );










                              break;
                            case Status.ERROR:

                              return EmptyListWidget(
                                  title: 'Error',
                                  subTitle: 'Something Went Wrong',
                                  image: 'images/error.png',
                                  titleTextStyle: Theme.of(context).typography.dense.display1.copyWith(color: Color(0xff9da9c7)),
                                  subtitleTextStyle: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6))

                              );
                              break;
                          }
                        }
                        return Container();
                      },
                    )
                ),
              )




            ]) ,
      );
    }




  }


