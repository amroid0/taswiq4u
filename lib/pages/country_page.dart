import 'package:animate_do/animate_do.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/country_bloc.dart';
import 'package:olx/data/bloc/languge_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/pages/welcome_page.dart';
import 'package:olx/utils/dailogs.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/fracation_sized_box.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  CountryBloc bloc;
  int selectedCountry = -1;
  bool isArabic = false;
  bool isEnglish = true;

  @override
  void initState() {
    preferences.clearCity();
    // TODO: implement initState
    bloc = new CountryBloc();
    bloc.getCountryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        // FractionallyAlignedSizedBox(
        //   bottomFactor: .6,
        //   child: Image.asset('images/logo.png'),
        // ),
        FractionallyAlignedSizedBox(
          bottomFactor: .6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isEnglish = true;
                    isArabic = false;
                  });
                  BlocProvider.of<TranslationsBloc>(context)
                      .setNewLanguage("en");
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 75,
                  //   color:Colors.green,
                  decoration: new BoxDecoration(
                    color: isEnglish == true ? Color(0xff53B553) : Colors.white,
                    borderRadius: new BorderRadius.circular(20.0),
                    border: Border.all(color: Color(0xffDCDCDC), width: 1),
                  ),
                  child: Center(
                    child: Text(allTranslations.text("page.lang"),
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: isEnglish == true
                                ? Colors.white
                                : Color(0xff818391))),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isEnglish = false;
                    isArabic = true;
                  });
                  BlocProvider.of<TranslationsBloc>(context)
                      .setNewLanguage("ar");
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 75,
                  decoration: new BoxDecoration(
                    color: isArabic == true ? Color(0xff53B553) : Colors.white,
                    borderRadius: new BorderRadius.circular(20.0),
                    border: Border.all(color: Color(0xffDCDCDC), width: 1),
                  ),
                  child: Center(
                    child: Text('العربية',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: isArabic == true
                                ? Colors.white
                                : Color(0xff818391))),
                  ),
                ),
              )
            ],
          ),
        ),
        FractionallyAlignedSizedBox(
          topFactor: .4,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<ApiResponse<List<CountryEntity>>>(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    switch (snapshot.data.status) {
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
                        List<CountryEntity> list = snapshot.data.data;
                        return SlideInUp(
                          child: ListView.separated(
                              itemCount: list.length,
                              separatorBuilder: (ctx, inde) => SizedBox(
                                    height: 16,
                                  ),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedCountry = index;
                                    });
                                    preferences.saveCountryID(
                                        list[index].countryId.toString());
                                    print("counnn" +
                                        list[index].countryId.toString());
                                    preferences.saveCountry(list[index]);
                                  },
                                  child: Container(
                                    //   color: Colors.white,
                                    decoration: new BoxDecoration(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Color(0xffDCDCDC), width: 0.5),
                                    ),
                                    child: ListTile(
                                        leading: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 0),
                                          child: Image.asset(
                                            list[index].countryId == 1
                                                ? 'images/egyptflag.png'
                                                : 'images/kuwaitflag.png',
                                            width: 60,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        title: Text(
                                          allTranslations.isEnglish
                                              ? list[index]
                                                  .englishDescription
                                                  .toString()
                                              : list[index].arabicDescription,
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        trailing: selectedCountry == index
                                            ? Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.green,
                                                size: 36,
                                              )
                                            : SizedBox()),
                                  ),
                                );
                                // return InkWell(
                                //     onTap: () {
                                //       /*Navigator.push(context,MaterialPageRoute(builder: (context) => CountryPage()))*/
                                //       preferences.saveCountryID(list[index].countryId.toString());
                                //       print("counnn"+list[index].countryId.toString());
                                //       preferences.saveCountry(list[index]);
                                //       Navigator.pushReplacement(context,
                                //           MaterialPageRoute(builder: (context) =>  MainScreen()));},
                                //     child:
                                //      Stack(
                                //           children:[
                                //      Container(
                                //      margin:  const EdgeInsets.symmetric(vertical: 0, horizontal: 25.0),
                                //       height: 60.0,
                                //       decoration: new BoxDecoration(
                                //         color: Color(0xffF2F4F6),
                                //         borderRadius: new BorderRadius.circular(10.0),
                                //       ),),
                                //         Positioned.directional(
                                //           textDirection: allTranslations.isEnglish?TextDirection.ltr:TextDirection.rtl,
                                //           start:0,
                                //           child: Padding(
                                //             padding: EdgeInsets.symmetric(horizontal: 4,vertical: 0),
                                //             child: Image.asset(
                                //               list[index].countryId==1?'images/egyptflag.png':'images/kuwaitflag.png',
                                //                 width: 60,
                                //                 height: 60,
                                //                 fit: BoxFit.fill,
                                //             ),
                                //           ),
                                //         ),
                                //          Align(alignment: Alignment.bottomCenter,child: Text(allTranslations.isEnglish?list[index].englishDescription.toString():list[index].arabicDescription, style: new TextStyle(fontSize: 20.0,fontWeight:FontWeight.w600),))
                                //   ]
                                //   ),
                                //
                                //   );
                              }),
                        );

                        break;
                      case Status.ERROR:
                        return EmptyListWidget(
                            title: 'Error',
                            subTitle: 'Something Went Wrong',
                            image: 'images/error.png',
                            titleTextStyle: Theme.of(context)
                                .typography
                                .dense
                                .display1
                                .copyWith(color: Color(0xff9da9c7)),
                            subtitleTextStyle: Theme.of(context)
                                .typography
                                .dense
                                .body2
                                .copyWith(color: Color(0xffabb8d6)));
                        break;
                    }
                  }
                  return Container();
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 60,
                child: Dialogs.commonButton(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelocmeScreen()));
                }, 'Continue')),
          ),
        )
      ]),
    );
  }
}
