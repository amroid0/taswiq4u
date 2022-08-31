import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/ToastUtils.dart';
import 'package:olx/utils/global_locale.dart';


import 'offer_detail_slider_page.dart';

class OfferSliderScreen extends StatefulWidget {
  int ImageIndex=0;

  OfferSliderScreen(this.ImageIndex);

  @override
  _OfferSliderScreenState createState() => _OfferSliderScreenState();
}


class _OfferSliderScreenState extends State<OfferSliderScreen> {
  PageController _pageController;
  List< PopupAdsEntityList>  list ;
  int currentPage=0;
  bool isFirstLoad=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null&&isFirstLoad) {
      isFirstLoad = false;
      list = arguments["list"] as List< PopupAdsEntityList> ;
      currentPage=arguments["index"]as int;
    }
    _pageController=PageController(initialPage: currentPage,viewportFraction:1, keepPage: true,);

    // _pageController.jumpToPage(currentPage);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black.withOpacity(.70),
          body:
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff202830),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    //set this opacity as per your requirement
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      tooltip: 'back',
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(

                    child: CarouselSlider(
                      height: MediaQuery.of(context).size.height * 0.60,
                      initialPage: currentPage,
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
                        widget.ImageIndex=index;
                        currentPage = index;
                        setState(() {
                        });

                        // _bloc.updateImageSliderNumber(index);
                      },
                      items: list.map((imgUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              width: MediaQuery.of(context).size.width-10,
                              margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
                              // decoration: BoxDecoration(
                              //   color: AppColors.appBackground,
                              // ),
                              child:   Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BlocProvider(bloc: new OfferBloc(),child: OfferSliderPage())
                                                ,settings: RouteSettings(arguments:{"list":list,"index":widget.ImageIndex})));

                                      },
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(12))
,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) => Image.asset("images/logo.png"),
                                            errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                                            imageUrl: APIConstants.getFullImageUrl(imgUrl.systemDataFile1==null?"":imgUrl.systemDataFile1.url==null ||imgUrl.systemDataFile1.url.isEmpty?"":imgUrl.systemDataFile1.url, ImageType.COMMAD)
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,

                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12) ,bottomRight: Radius.circular(12) )
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: <Widget>[
                                        Text(
                                          list[currentPage].description==null?"":list[currentPage].description,
                                          style: TextStyle(color: Color(0xff2D3142)),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Row(children: <Widget>[
                                              _buildViewWidget(currentPage, list[currentPage]),
                                              SizedBox(
                                                width: 4,
                                              ),
                                            ]),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            _buildLikeWidget(currentPage, list[currentPage]),
                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
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
            ),
          )
      ),
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

        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(onTap:(){
                BlocProvider.of<OfferBloc>(context).likeAds(pos,true);

              },child: Icon(Icons.remove_red_eye,color:AppColors.accentColor ),),
              SizedBox(width: 4,),
              Text(viewCounter.count.toString(),style: TextStyle(color: AppColors.accentColor,)),
            ]
        );
      },
    );


  }

  Widget _buildLikeWidget(int pos,PopupAdsEntityList item){

    return   StreamBuilder<Counter>(
      initialData:Counter(item.likes,item.isLiked) ,
      stream: BlocProvider.of<OfferBloc>(context).Likestream,
      builder: (context,snapshot){
        Counter likeCounter=Counter(0,false);
        if(snapshot.hasData)
          likeCounter=snapshot.data;
        else if(snapshot.hasError){
          ToastUtils.showWarningMessage(allTranslations.text('ensure_login'));

        }
        return  Row(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(onTap:(){
                if(!likeCounter.isLiked)
                  BlocProvider.of<OfferBloc>(context).likePopUpAds(item,true);

              },child: Icon(likeCounter.isLiked?Icons.thumb_up : Icons.thumb_up_outlined,color: AppColors.accentColor,)),
              SizedBox(width: 4,),
              Text(likeCounter.count.toString(),style: TextStyle(color: AppColors.accentColor),),

            ]
        );
      },
    );


  }





}
