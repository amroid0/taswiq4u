import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/profile_bloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/user_info.dart';
import 'package:olx/pages/bundle_page.dart';
import 'package:olx/pages/change_pass_page.dart';
import 'package:olx/pages/edit_profile_page.dart';
import 'package:olx/pages/my_ads_page.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    _bloc = BlocProvider.of<ProfileBloc>(context);
    _bloc.getUserProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
/*
    appBarTitle=Text(searchQuery,style:TextStyles.appBarTitle ,);
*/
    //BlocProvider.of<ProfileBloc>(context).getFavroite(1);
    return Scaffold(
        body:
            /*Column(
        children: <Widget>[



          Expanded(
            child: StreamBuilder<ApiResponse<AdvertisementList>>(
              stream: BlocProvider.of<ProfileBloc>(context).stream,
              builder:(context,snap){
                switch(snap.data.status) {
                  case Status.LOADING:
                    return new Center(
                      child: new CircularProgressIndicator(
                        backgroundColor: Colors.deepOrangeAccent,
                        strokeWidth: 5.0,
                      ),
                    );
                    break;

                  case Status.COMPLETED:
                    AdvertisementList ads=snap.data.data as AdvertisementList;
                    if(ads.list!=null)
                      return _buildAdsList(ads);
                    break;
                  case Status.ERROR:
                    return Center(child: Text(allTranslations.text('err_wrong')));
                    break;
                }
                return Container();



              },
            ),
          )

        ],
      ),*/
            StreamBuilder<ApiResponse<UserInfo>>(
                stream: _bloc.stream,
                builder: (context, snap) {
                  if (snap.data != null)
                    switch (snap.data.status) {
                      case Status.LOADING:
                        return new Center(
                          child: new CircularProgressIndicator(
                            backgroundColor: Colors.deepOrangeAccent,
                            strokeWidth: 5.0,
                          ),
                        );

                        break;

                      case Status.COMPLETED:
                        var obj = snap.data.data as UserInfo;
                        return _buildProfile(obj);
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
                  return Container();
                }));
  }

  Widget _buildProfile(UserInfo obj) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            _BuildProifleImage(obj.image, 200, 200),
            SizedBox(
              height: 8,
            ),
            Text(
              "${obj.firstName} ${obj.secondName}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              obj.phone,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(
              height: 24,
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyAdsPage(),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/my_ads.png',
                              width: 45,
                              height: 45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(allTranslations.text('my_ads'))
                          ],
                        ),
                        Icon(
                          allTranslations.isEnglish
                              ? Icons.arrow_forward_ios_outlined
                              : Icons.arrow_back_ios_sharp,
                          color: Colors.black87,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                bloc: ProfileBloc(), child: BundleScreen())),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/bundles.png',
                              width: 45,
                              height: 45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(allTranslations.text('bundle'))
                          ],
                        ),
                        Icon(
                          allTranslations.isEnglish
                              ? Icons.arrow_forward_ios_outlined
                              : Icons.arrow_back_ios_sharp,
                          color: Colors.black87,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                bloc: ProfileBloc(),
                                child: EditProfileScreen())),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/edit_profile.png',
                              width: 45,
                              height: 45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(allTranslations.text('edit_profile'))
                          ],
                        ),
                        Icon(
                          allTranslations.isEnglish
                              ? Icons.arrow_forward_ios_outlined
                              : Icons.arrow_back_ios_sharp,
                          color: Colors.black87,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChnagePassScreen(),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/change_password.png',
                              width: 45,
                              height: 45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(allTranslations.text('change_pass'))
                          ],
                        ),
                        Icon(
                          allTranslations.isEnglish
                              ? Icons.arrow_forward_ios_outlined
                              : Icons.arrow_back_ios_sharp,
                          color: Colors.black87,
                          size: 30,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     SizedBox(width: 10,),
            //     Expanded(
            //       child: GestureDetector(
            //         onTap: (){
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>  BlocProvider(
            //                     bloc: ProfileBloc(),child:SettingsPage())),
            //           );
            //         },
            //         child: Container(
            //           height: 60.0,
            //           padding: EdgeInsets.all(4),
            //           decoration: new BoxDecoration(
            //             color: Colors.green,
            //             borderRadius: new BorderRadius.circular(10.0),
            //           ),
            //           child:  Stack(children:<Widget>[
            //             Align( child: new Text(allTranslations.text('setting'), style: new TextStyle(fontSize: 18.0, color: Colors.white),)
            //               ,alignment: Alignment.center,),
            //
            //
            //
            //           ]
            //
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 10,),
            //
            //     Expanded(
            //       child: GestureDetector(
            //         onTap: (){
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>  BlocProvider(
            //                     bloc: ProfileBloc(),child:BundleScreen())),
            //           );
            //         },
            //         child: Container(
            //           height: 60.0,
            //           padding: EdgeInsets.all(4),
            //           decoration: new BoxDecoration(
            //             color: Colors.green,
            //             borderRadius: new BorderRadius.circular(10.0),
            //           ),
            //           child:  Stack(children:<Widget>[
            //             Align( child: new Text(allTranslations.text('bundle'), style: new TextStyle(fontSize: 18.0, color: Colors.white),)
            //               ,alignment: Alignment.center,),
            //
            //
            //
            //           ]
            //
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 10,),
            //
            //   ],
            //
            // )
          ],
        ),
      ),
    );
  }

  Widget _BuildProifleImage(String url, double width, double height) {
    return CircleAvatar(
      radius: 80.0,
      backgroundImage: NetworkImage((url != null)
          ? APIConstants.getFullImageUrl(url, ImageType.ADS)
          : ""),
      backgroundColor: Colors.grey,
    );
  }
}
