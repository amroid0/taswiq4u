
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/country_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/pages/login_page.dart';
import 'package:olx/pages/main_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
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
    // TODO: implement initState
    bloc=new CountryBloc();
    bloc.getCountryList();
    super.initState();
  }



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
                            return ListView.builder(
                              itemCount: list.length,

                                itemBuilder: (BuildContext context,int index){

                              return
                                InkWell(
                                  onTap: () {
                                    /*Navigator.push(context,MaterialPageRoute(builder: (context) => CountryPage()))*/
                                    preferences.saveCountryID(list[index].countryId.toString());
                                    preferences.saveCountry(list[index]);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => MainScreen()));},
                                  child: new Container(
                                    margin:  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    height: 60.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    child: new Center(child: new Text(list[index].name, style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                                  ),
                                );
                            });










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


