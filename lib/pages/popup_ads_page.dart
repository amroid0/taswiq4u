import 'package:flutter/material.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:olx/utils/Constants.dart';

class PopUpAdsPage extends StatefulWidget {
  @override
  _PopUpAdsPageState createState() => _PopUpAdsPageState();
}

class _PopUpAdsPageState extends State<PopUpAdsPage> {
  PopupAdsEntityList result;
  @override
  void initState() {


    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    result = ModalRoute
        .of(context)
        .settings
        .arguments;

    return new Scaffold(

      body: Stack(
        children: <Widget>[
          Align(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.6,
              child:  FadeInImage.assetNetwork(
                                      fit: BoxFit.fill,

                placeholder: 'images/logo.png',
                image: APIConstants.getFullImageUrl(result.systemDataFile!=null ?result.systemDataFile.url:"", ImageType.COMMAD)
              ),
              margin:EdgeInsets.only(top:70,left:20,right: 20),

),
            alignment:Alignment.topLeft,
          ),





          Align(

            alignment:Alignment.topLeft ,
            child: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Container(
                margin:EdgeInsets.only(top:70,left: 20,right: 20),
                color: Colors.grey.withOpacity(0.5), //set this opacity as per your requirement
                child: IconButton(
                  iconSize: 30,

                  icon: Icon(Icons.close,color: Colors.white,),
                  onPressed: () {
                    Navigator.pop(context);

                  },
                  tooltip: 'back',
                ),
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

                  Text(result.category.name.toString(),style: TextStyle(color: Colors.white),),
                  SizedBox(height: 16,),
                  Text(result.description,style: TextStyle(color: Colors.white),),
                  SizedBox(height: 16,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                     Column(mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(result.likes.toString(),style: TextStyle(color: Colors.white),),
                                FlatButton(onPressed:(){
  //                                bloc.likeAds(true);

                                },child: Icon(Icons.favorite,color: Colors.white,)),
                              ]
                          ),

                      Column(mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(result.viewsCount.toString(),style: TextStyle(color: Colors.white),),
                            FlatButton(onPressed:(){
                              //                                bloc.likeAds(true);

                            },child: Icon(Icons.remove_red_eye,color: Colors.white,)),
                          ]
                      ),




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
    );
  }
}


