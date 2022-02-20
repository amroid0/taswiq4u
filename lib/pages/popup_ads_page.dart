import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/ToastUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class PopUpAdsPage extends StatefulWidget {
  @override
  _PopUpAdsPageState createState() => _PopUpAdsPageState();
}

class _PopUpAdsPageState extends State<PopUpAdsPage> {
  PopupAdsEntityList result;
  OfferBloc bloc;
  @override
  void initState() {
   bloc =OfferBloc();
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
                image: APIConstants.getFullImageUrl(result.systemDataFile1!=null ?result.systemDataFile1.url:"", ImageType.COMMAD)
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

                  Text("Ads Category",style: TextStyle(color: Colors.white),),
                  SizedBox(height: 16,),
                  Text(result.description,style: TextStyle(color: Colors.white),),
                  SizedBox(height: 16,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    _buildLikeWidget(result),
                      InkWell(
                          onTap: ()async{
                            var whatsappUrl ="whatsapp://send?phone=${result.phoneNumber}";
                            await canLaunch(whatsappUrl)? launch(whatsappUrl):ToastUtils.showErrorMessage("رقم الهاتف غير صحيح");;

                          },

                          child: Icon(MdiIcons.whatsapp,color: Colors.white,size: 36,)),
                      SizedBox(width: 12,),
                      InkWell(
                          onTap: ()async{
                            const url = "http://taswiq4u.com/";
                            if (await canLaunch(url))
                              await launch(url);
                            else
                              // can't launch url, there is some error
                              throw "Could not launch $url";
                          },
                          child: Icon(Icons.language_outlined,color: Colors.white,size: 36,)),
                      SizedBox(width: 12,),
                      InkWell(
                          onTap: ()async{
                            final url = result.instagramLink;
                            if (await canLaunch(url))
                              await launch(url);
                            else
                              // can't launch url, there is some error
                              ToastUtils.showErrorMessage("اللينك غير صالح");
                          },
                          child: Icon(MdiIcons.instagram,color: Colors.white,size: 36,)),

                   SizedBox(width: 12,),
                      InkWell(
                          onTap: ()async{
                            final url = result.phoneNumber;
                            if (await canLaunch('tel:$url'))
                              await launch('tel:$url');
                            else
                              // can't launch url, there is some error
                              ToastUtils.showErrorMessage("رقم الهاتف غير صحيح");
                          },
                          child: Icon(MdiIcons.phone,color: Colors.white,size: 36,)),



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

  Widget _buildLikeWidget(PopupAdsEntityList item) {
    return StreamBuilder<Counter>(
      initialData: Counter(item.likes, true),
      stream: bloc.Likestream,
      builder: (context, snapshot) {
        Counter likeCounter = Counter(0, true);
        if (snapshot.hasData)
          likeCounter = snapshot.data;
        return Column(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(likeCounter.count.toString(),
                style: TextStyle(color: Colors.white),),
              FlatButton(onPressed: () {
               if( likeCounter.isEanbled)
                bloc.likePopUpAds(result,true);
              },
                  child: Icon(
                    likeCounter.isEanbled ? Icons.favorite_border : Icons
                        .favorite, color: Colors.white,)),
            ]
        );
      },
    );
  }


}


