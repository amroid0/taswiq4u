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

  _bloc = new CategoryBloc();

  _bloc.popupStream..listen((data){
    switch (data.status) {
      case Status.LOADING:

        break;



      case Status.ERROR:

        break;
      case Status.COMPLETED:
        var response=data.data;
        if(response!=null)
        _openAddEntryDialog(data.data[0]);


        break;

  }});


  super.initState();

  }
  @override
  Widget build(BuildContext context) {
    _bloc.submitQuery("");
    return  WillPopScope(
      onWillPop: (){
        if(_bloc.isStackIsEmpty()){
          SystemNavigator.pop();

        }else {
          _bloc.removeCateogryFromStack();
        }
      },
      child: Container(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
             _buildMainSlider(_bloc),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(imgList, (index, url) {
                  return StreamBuilder<int>(
                    initialData: 0,
                    stream: _bloc.imageNumberStream,
                    builder: (context,snap) {
                      return Container(
                        width: 7.0,
                        height: 7.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: snap.data == index ? Theme
                              .of(context)
                              .accentColor : Colors.black26,
                        ),
                      );

                    });
                }),
              ),

              Expanded(
                child: StreamBuilder<List<CateogryEntity>>(
                  stream: _bloc.stream,
                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return Text(allTranslations.text('loading'));
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
                if(response.data[i].systemDataFile!=null){
                  imgList.add(response.data[i].systemDataFile.url);
                }
              }
                }

              carouselSlider = CarouselSlider(

                height: MediaQuery.of(context).size.height*.25,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                pauseAutoPlayOnTouch: Duration(seconds: 2),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  ImageIndex=index;

                  _bloc.updateImageSliderNumber(index);
                },
                items: imgList.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
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
    return ListView.builder(
      itemCount: category.length,
      itemBuilder: (BuildContext context,int index){


        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: new InkWell(
            onTap: (){
              if(category[index].hasSub){
                _bloc.addCateogryToStack(category[index].subCategories);
              }else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlocProvider(bloc:_bloc,child: BlocProvider(bloc: AdsBloc(),child:SearchAnnounceListScreen(category[index]),)),
                settings: RouteSettings(arguments:category[index] )

                ),
              );
              }

            },
            child: new Card(
              child: new SizedBox(
                height: 70.0,
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Expanded(
                      child: new ListTile(
                        title: new Text(category[index].name,textAlign:TextAlign.end),
                        subtitle: Text(allTranslations.isEnglish?category[index].englishDescription:category[index].arabicDescription,textAlign: TextAlign.end,),
                        leading: Icon(allTranslations.isEnglish?Icons.keyboard_arrow_left:Icons.keyboard_arrow_right,color: Colors.black,),
                      ),
                    ),
                    new Container(
                      width: 60,
                     height: 60,
                     /* decoration: BoxDecoration(
                          color: Colors.white,


                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,)
                          ]),*/
                      margin: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child:
                      CachedNetworkImage(
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Image.asset("images/logo.png"),
                        errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                        imageUrl: APIConstants.getFullImageUrl(category[index].categoryLogo, ImageType.CATE)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );


      },
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