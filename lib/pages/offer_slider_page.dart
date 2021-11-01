import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/offfer_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/widget/base64_image.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

import 'offer_detail_slider_page.dart';

class OfferSliderScreen extends StatefulWidget {
  @override
  _OfferSliderScreenState createState() => _OfferSliderScreenState();
}


class _OfferSliderScreenState extends State<OfferSliderScreen> {
  PageController _pageController;
  List< PopupAdsEntityList>  list ;
  int currentPage=0;
  int ImageIndex=0 ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      list = arguments["list"] as List< PopupAdsEntityList> ;
      currentPage=arguments["index"]as int;
    }
    _pageController=PageController(initialPage: currentPage,viewportFraction:1, keepPage: true,);

    // _pageController.jumpToPage(currentPage);
    return Scaffold(
      backgroundColor:Colors.black,
        body:
        Stack(
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height*.7,
                  color:Colors.white,
                ),
              ),
              Container(
                margin:EdgeInsets.only(top:MediaQuery.of(context).size.height*.1),
                child: CarouselSlider(
                  height: MediaQuery.of(context).size.height*.7,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  aspectRatio: 2,
                  autoPlay: false,
                  reverse: false,

                  viewportFraction: 0.9,
                  enableInfiniteScroll: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 3000),
                  pauseAutoPlayOnTouch: Duration(seconds: 3),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    ImageIndex=index;

                    // _bloc.updateImageSliderNumber(index);
                  },
                  items: list.map((imgUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width-10,
                          margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
                          // decoration: BoxDecoration(
                          //   color: AppColors.appBackground,
                          // ),
                          child:   GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(bloc: new OfferBloc(),child: OfferSliderPage())
                                      ,settings: RouteSettings(arguments:{"list":list,"index":ImageIndex})));

                            },
                            child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Image.asset("images/logo.png"),
                                errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                                imageUrl: APIConstants.getFullImageUrl(imgUrl.systemDataFile==null?"":imgUrl.systemDataFile.url==null ||imgUrl.systemDataFile.url.isEmpty?"":imgUrl.systemDataFile.url, ImageType.COMMAD)
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),



              Align(

                alignment:AlignmentDirectional.topStart ,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30,horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);

                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 18,
                      child: Center(child: Icon(Icons.close,color: Colors.white,size: 30,)),

                    ),
                  ),
                ),
              ),


              // Align(
              //   alignment: Alignment.bottomLeft,
              //
              //   child: Container(
              //
              //     color: Color(0xFF0E3311).withOpacity(0.7),
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min
              //       ,
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: <Widget>[
              //
              //         SizedBox(height: 4,),
              //         Text(list[currentPage].description==null?"":list[currentPage].description,style: TextStyle(color: Colors.white),),
              //         SizedBox(height: 16,),
              //
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             _buildLikeWidget(currentPage,list[currentPage]),
              //
              //             InkWell(
              //                 onTap: ()async{
              //                   var whatsappUrl ="whatsapp://send?phone=${201119726142}";
              //                   await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
              //
              //                 },
              //                 child: Icon(MdiIcons.whatsapp,color: Colors.white,size: 40,)),
              //
              //             _buildViewWidget(currentPage,list[currentPage])
              //           ],)
              //
              //       ],
              //     ),
              //   ),
              // ),




            ]
        )
    );
  }

  Widget _buildViewWidget(int pos,PopupAdsEntityList item){

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
              FlatButton(onPressed:(){
                BlocProvider.of<OfferBloc>(context).likeAds(pos,true);

              },child: Icon(Icons.remove_red_eye,color: Colors.white),),
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
