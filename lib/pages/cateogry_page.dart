import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:olx/pages/popup_ads_page.dart';
import 'package:olx/pages/ads_list_page.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:shimmer/shimmer.dart';

import 'offer_detail_slider_page.dart';

class CategoryListFragment extends StatefulWidget {
  CategoryListFragment() : super();

  final String title = "Carousel Demo";

  @override
  CarouselDemoState createState() => CarouselDemoState();
}

class CarouselDemoState extends State<CategoryListFragment> {
  CategoryBloc  _bloc;
  List<CateogryEntity>totalCateogryList;

  //
  CarouselSlider carouselSlider;
  List imgList = [];

  int ImageIndex=0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
@override
  void initState() {
    // TODO: implement initState

  _bloc = BlocProvider.of<CategoryBloc>(context);

  _bloc.popupStream..listen((data){
    switch (data.status) {
      case Status.LOADING:

        break;



      case Status.ERROR:

        break;
      case Status.COMPLETED:
        var response=data.data;
        if(response!=null&&response.isNotEmpty)
        _openAddEntryDialog(data.data[0]);


        break;

  }});


  super.initState();

  }
  @override
  Widget build(BuildContext context) {
    _bloc.submitQuery("");
    return  Container(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           _buildMainSlider(_bloc),


            Expanded(
              child: StreamBuilder<List<CateogryEntity>>(
                stream: _bloc.stream,
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return  Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: ListView.builder(
                        itemBuilder: (_, __) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),

                        ),
                        itemCount: 15,
                      ));

                  }
                  if(imgList.isEmpty){
                    _bloc.getMainSliderAds();
                  }
                  return _buildCategoryList(snapshot.data);
                }
              ),
            )




          ],
        ),

    );
  }

  Widget _buildMainSlider(CategoryBloc bloc){
   return StreamBuilder<ApiResponse<List<PopupAdsEntityList>>>(
        stream: _bloc.mainSliderStreaam,
        builder: (context, snapshot) {
          if(snapshot.hasData)
          switch (snapshot.data.status) {
            case Status.LOADING:
              break;


            case Status.ERROR:
              break;
            case Status.COMPLETED:
              if(BlocProvider.of<LoginBloc>(context).isfirstPopupAd){
              _bloc.getPopupAds();
              BlocProvider.of<LoginBloc>(context).isfirstPopupAd=false;
              }
              var response = snapshot.data;
              if (response != null) {
                imgList.clear();
                for(int i=0;i<response.data.length;i++){
                if(response.data[i].systemDataFile1!=null){
                  imgList.add(response.data[i].systemDataFile1.url);
                }
              }
                }
              if(imgList.isNotEmpty){

              carouselSlider = CarouselSlider(

                height: MediaQuery.of(context).size.height*.28,
                initialPage: 0,
                enlargeCenterPage: true,
                aspectRatio: 1,
                autoPlay: true,
                reverse: false,

                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 3000),
                pauseAutoPlayOnTouch: Duration(seconds: 3),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  ImageIndex=index;

                  _bloc.updateImageSliderNumber(index);
                },
                items: imgList.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width-10,
                        margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.appBackground,
                        ),
                        child:   GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(bloc: new OfferBloc(),child: OfferSliderPage())
                                    ,settings: RouteSettings(arguments:{"list":response.data,"index":ImageIndex})));

                          },
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                              placeholder: (context, url) => Image.asset("images/logo.png"),
                              errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                              imageUrl: APIConstants.getFullImageUrl(imgUrl, ImageType.COMMAD)
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
          return carouselSlider;
              }else {
                return Container(
                  margin: EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height*.25,
                  color: AppColors.appBackground,
                  child:Center(child: Icon(Icons.image,color:Colors.grey,size: 60,)
                  ),
                );
              }

              break;
          }
          return Container(
            margin: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height*.25,
            color: AppColors.appBackground,
            child:Center(child: Icon(Icons.image,color:Colors.grey,size: 60,)
            ),
          );
        }
        );


  }

  Widget _buildCategoryList(List<CateogryEntity> category){
    return SlideInUp(
      child: Column(
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: FittedBox(
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                children: _bloc.cateogyTitle.map((e) => Text(allTranslations.isEnglish ?"${e.englishDescription}  |  ":"${e.arabicDescription}  |  ",style: TextStyle(fontSize: 13),)).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: category.length,
              itemBuilder: (BuildContext context,int index){


                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: new InkWell(
                    onTap: (){
                      if(category[index].hasHorizontal){
                        _bloc.addCateogryToStack(category[index],false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BlocProvider(bloc:_bloc,child: BlocProvider(bloc: AdsBloc(),child:SearchAnnounceListScreen(category[index]),)),
                              settings: RouteSettings(arguments:category[index] )

                          ),
                        );
                      }
                      else if(category[index].hasSub){
                        _bloc.addCateogryToStack(category[index]);
                      }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlocProvider(bloc:_bloc,child: BlocProvider(bloc: AdsBloc(),child:SearchAnnounceListScreen(category[index]),)),
                        settings: RouteSettings(arguments:category[index] )

                        ),
                      );
                      }

                    },
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [

                        Container(
                          margin: EdgeInsetsDirectional.only(start: 30),
                          child: new Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 20,),
                                 Expanded(
                                   child: ListTile(


                                     title: new Text(allTranslations.isEnglish?category[index]
                                         .englishDescription:category[index]
                                         .arabicDescription,style: TextStyle(fontSize: 15),),
                                     subtitle:RichText(text: TextSpan(
                                     children: [
                                       TextSpan(text: '20 ',style: TextStyle(color: Colors.grey)),
                                       TextSpan(text: allTranslations.text('ads'),style: TextStyle(color: Colors.grey))
                                     ]
                                   ),),
                                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,),
                                ),
                                 ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade300,

                            child: Container(
                              height: 55,
                              width: 55,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset("images/logo.png"),
                                    errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                                    imageUrl: APIConstants.getFullImageUrl(category[index].categoryLogo, ImageType.CATE)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );


              },
            ),
          ),
        ],
      ),
    );


  }


  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  void _openAddEntryDialog(PopupAdsEntityList data) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) {
          return  PopUpAdsPage();
        },settings: RouteSettings(arguments:data),
        fullscreenDialog: true
    ));
  }
}