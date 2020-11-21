import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/offfer_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/widget/base64_image.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';

class OfferSliderPage extends StatefulWidget {
  @override
  _OfferSliderPageState createState() => _OfferSliderPageState();
}


class _OfferSliderPageState extends State<OfferSliderPage> {
  PageController _pageController;
  List< PopupAdsEntityList>  entity;
   int currentPage=0;
  @override
  Widget build(BuildContext context) {


    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      entity = arguments["list"] as List< PopupAdsEntityList> ;
      currentPage=arguments["index"]as int;
    }
    _pageController=PageController(initialPage: currentPage,viewportFraction: 1, keepPage: true);
   // _pageController.jumpToPage(currentPage);
         return Scaffold(
           body: PageView.builder(
             controller: _pageController,
             itemBuilder: (context,pos){
               PopupAdsEntityList item =entity[pos];

             return Stack(
               alignment: AlignmentDirectional.bottomStart,
               children: <Widget>[
             Container(
             width: double.infinity,
               height: double.infinity,
               child:  FadeInImage.assetNetwork(
                   placeholder: 'images/logo.png',
                   image: APIConstants.getFullImageUrl(item.systemDataFile!=null ?item.systemDataFile.url:"", ImageType.COMMAD)
               ),

             ),

               Align(
               alignment: Alignment.centerLeft,
               child: FlatButton(
             onPressed: (){
                   _pageController.nextPage(duration: kTabScrollDuration, curve: Curves.ease);

             },
             padding: EdgeInsets.all(0.0),
             child:Icon(Icons.arrow_forward_ios,color: Colors.white,size: 40,))
             ),
               Align(
                     alignment: Alignment.centerRight,
                     child: FlatButton(
                         onPressed: (){
                           _pageController.previousPage(duration: kTabScrollDuration, curve: Curves.ease);

                         },
                         padding: EdgeInsets.all(0.0),
                         child:Icon(Icons.arrow_back_ios,size:40,color: Colors.white,))
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

                    SizedBox(height: 4,),
                    Text(item.description==null?"":item.description,style: TextStyle(color: Colors.white),),
                    SizedBox(height: 16,),

                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLikeWidget(pos,item),

                      _buildViewWidget(item)
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
             );
           },
             itemCount: entity.length,
           ),
         );
  }

 Widget _buildViewWidget(PopupAdsEntityList item){

 return   StreamBuilder<Counter>(
   initialData:Counter(item.viewsCount,true) ,
      stream: BlocProvider.of<OfferBloc>(context).viewstream,
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
    );


  }

  Widget _buildLikeWidget(int pos,PopupAdsEntityList item){

    return   StreamBuilder<Counter>(
      initialData:Counter(item.likes,true) ,
      stream: BlocProvider.of<OfferBloc>(context).Likestream,
      builder: (context,snapshot){
        Counter likeCounter=Counter(0,true);
        if(snapshot.hasData)
          likeCounter=snapshot.data;
        return  Column(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(likeCounter.count.toString(),style: TextStyle(color: Colors.white),),
              FlatButton(onPressed:(){
                BlocProvider.of<OfferBloc>(context).likeAds(pos,true);

              },child: Icon(likeCounter.isEanbled?Icons.favorite_border:Icons.favorite,color: Colors.white,)),
            ]
        );
      },
    );


  }
}
