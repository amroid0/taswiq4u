import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/commerical_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/widget/base64_image.dart';

class FullComerialScreen extends StatefulWidget {
  @override
  _FullComerialScreenState createState() => _FullComerialScreenState();
}

class _FullComerialScreenState extends State<FullComerialScreen> {
  String commerialAdsId;

  CommercialAdsList detailArgs;
  CommericalBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    bloc=new CommericalBloc();


    super.initState();
    bloc.GetImage();
    bloc.viewAds();
    bloc.likeAds(false);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    bloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     detailArgs=ModalRoute.of(context).settings.arguments;
     bloc.setDefaultData(detailArgs);


    // _pageController.jumpToPage(currentPage);
    return BlocProvider<CommericalBloc>(
      bloc: bloc,
      child: Scaffold(

        body: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: StreamBuilder<String>(
                      stream: bloc.Imagestream,
                      builder: (context,snapshot){
                     return
                       ImageBox(
                         imgSrc:snapshot.hasData?snapshot.data:"" ,
                         defaultImg:"images/logo.png",
                         boxFit:BoxFit.cover,
                       );

                      }


                    ),
                  ),
                  Align(

                    alignment:Alignment.topLeft ,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                        onPressed: () {
                          Navigator.pop(context);

                        },
                        tooltip: 'back',
                      ),
                    ),
                  ),



                  Align(
                    alignment: Alignment.bottomLeft,

                    child: Container(

                      color: Color(0xFF0E3311).withOpacity(0.7),
                      child: Column(
                        mainAxisSize: MainAxisSize.min
                        ,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(height: 8,),

                          Text(detailArgs.Link.toString(),style: TextStyle(color: Colors.white),),
                          SizedBox(height: 16,),
                          Text(detailArgs.Description,style: TextStyle(color: Colors.white),),
                          SizedBox(height: 16,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                StreamBuilder<Counter>(
                                  stream: bloc.Likestream,
                                  builder: (context,snapshot){
                                    Counter likeCounter=Counter(0,false);
                                     if(snapshot.hasData)
                                     likeCounter=snapshot.data;
                                  return  Column(mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(likeCounter.count.toString(),style: TextStyle(color: Colors.white),),
                                          FlatButton(onPressed:(){
                                            if(!likeCounter.isLiked) {
                                              bloc.likeAds(true);
                                            }
                                          },child: Icon(likeCounter.isLiked?Icons.favorite:Icons.favorite_border,color: Colors.white,)),
                                        ]
                                    );
                                  },
                                ),

                              StreamBuilder<Counter>(
                                stream: bloc.viewstream,
                                builder: (context,snapshot){
                                  Counter viewCounter=Counter(0,true);
                                  if(snapshot.hasData)
                                    viewCounter=snapshot.data;

                                 return Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(viewCounter.count.toString(),style: TextStyle(color: Colors.white),),
                                        FlatButton(onPressed:(){},child: Icon(Icons.remove_red_eye,color: Colors.white),),
                                      ]
                                  );
                                },
                              )
                            ],)

                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget>[
                        ]
                    ),
                  )],
              )
    ));





}}
