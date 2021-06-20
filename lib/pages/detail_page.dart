import 'dart:io';

import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/detail_bloc.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/ads_detail.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/pages/edit_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/slider_full+image_viewer.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/favroite_widget.dart';
import 'package:olx/widget/map_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_viewer_page.dart';
import 'offer_detail_slider_page.dart';

class DetailPage extends StatefulWidget {
 bool isEditable;


 DetailPage(this.isEditable);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailBloc _bloc;
  GoogleMapController _mapController;
  final detailScaffoldMessengerKey = GlobalKey<ScaffoldState>();


  final Set<Marker> _markers = {};
  AdsModel detailArgs;

  FavroiteBloc favbloc;

  AdsDetail detail;

  @override
  void initState() {
    // TODO: implement initState
    _bloc = DetailBloc();

    favbloc=new FavroiteBloc();

    favbloc.stateStream.listen((data) {
      // Redirect to another view, given your condition

      switch (data.status) {
        case Status.LOADING:

          break;



        case Status.ERROR:

          break;
        case Status.COMPLETED:
        // TODO: Handle this case.
          var isLogged=data as ApiResponse<bool>;
          var isss=isLogged.data;
          if(isss) {
            Fluttertoast.showToast(
                msg: "Favorite",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }else{

            Fluttertoast.showToast(
                msg: "UnFavorite",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );



          }
          break;

      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    detailArgs = ModalRoute.of(context).settings.arguments;
    _bloc.getAdsDetail(detailArgs.Id.toString());
    return BlocProvider<DetailBloc>(
      bloc: _bloc,
      child: Scaffold(
        key: detailScaffoldMessengerKey,


        floatingActionButton:
        SpeedDial(
          /// both default to 16
          marginEnd: 18,
          marginBottom: 20,
          // animatedIcon: AnimatedIcons.menu_close,
          // animatedIconTheme: IconThemeData(size: 22.0),
          /// This is ignored if animatedIcon is non null
          icon: Icons.call,
          activeIcon: Icons.call,
          // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
          /// The label of the main button.
          // label: Text("Open Speed Dial"),
          /// The active label of the main button, Defaults to label if not specified.
          // activeLabel: Text("Close Speed Dial"),
          /// Transition Builder between label and activeLabel, defaults to FadeTransition.
          // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
          /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
          buttonSize: 56.0,
          visible: true,
          /// If true user is forced to close dial manually
          /// by tapping main button and overlay is not rendered.
          closeManually: false,
          /// If true overlay will render no matter what.
          renderOverlay: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'phone',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,

          elevation: 8.0,
          shape: CircleBorder(),
          // orientation: SpeedDialOrientation.Up,
          // childMarginBottom: 2,
          // childMarginTop: 2,
          children: [
            SpeedDialChild(
              child: Icon(Icons.textsms,color: Colors.white,),
              backgroundColor: Colors.green,
              label: 'محادثه',
              labelBackgroundColor: Colors.white,

              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () =>_textMe(),
              onLongPress: () => print('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.call,color: Colors.white,),
              backgroundColor: Colors.green,
              label: 'اتصال',
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: Colors.white,
              onTap: (){
                _makePhoneCall('tel:${detailArgs.UserPhone}');
              },
              onLongPress: () => print('SECOND CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.copy,color: Colors.white,),
              backgroundColor: Colors.green,
              label: 'نسخ الرقم',
              labelBackgroundColor: Colors.white,
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () =>  Clipboard.setData(new ClipboardData(text: detailArgs.UserPhone)).then((_){
                detailScaffoldMessengerKey.currentState.showSnackBar(
                    SnackBar(content:Text("تم النسخ")));
              }),
              onLongPress: () => print('THIRD CHILD LONG PRESS'),
            ),
          ],
        ),


        /* FloatingActionButton(
          child: Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () {
            _makePhoneCall('tel:${detailArgs.UserPhone}');
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.black,
        )*/
        body: StreamBuilder<ApiResponse<AdsDetail>>(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return  Stack(
                  children: [
                    Positioned(
                      top: 10,
                      child: Expanded(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            enabled: true,
                            child:Container(

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 300.0,
                                    color: Colors.white,

                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.0),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 40.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.0),
                                          ),
                                          Expanded(
                                            child: ListView.builder(itemBuilder: (_,__)=>
                                                Container(
                                                  width: double.infinity,
                                                  height: 22.0,
                                                  color: Colors.white,
                                                ),
                                              itemCount: 15,


                                            ),
                                          )


                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),

                            ),
                          )
                      ),
                    ),
                  ],
                );
                break;
              case Status.COMPLETED:
                var value = snapshot.data.data;
                 detail = value as AdsDetail;
                //_bloc.viewAds();
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Stack(children: [
                      gettSliderImageWidget(detail.AdvertismentImages),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: AlignmentDirectional.topStart,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 18,

                                      backgroundColor: Colors.black.withOpacity(.4),
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                        ),
                                      ),

                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              Visibility(
                                visible: widget.isEditable,
                                child: GestureDetector(

                                  onTap: (){

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => BlocProvider(bloc: AdsBloc(),child:EditPage(detail),),
                                            settings: RouteSettings(arguments:detail)

                                        ));






                                  },
                                  child: Container(

                                      decoration: BoxDecoration(
                                          color: Color(0xffECECEC).withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Icon(
                                        Icons.edit,
                                        size: 30.0,
                                        color: Colors.black,
                                      )),
                                ),
                              ),



                            ],
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                          margin:EdgeInsets.only(top:305,left:12.0,right: 12.0),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.end ,
                            children: [
                              Container(
                                 // margin:EdgeInsets.only(top:300,left:12.0,right: 12.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffECECEC).withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20)),
                                  child:FavroiteWidget(onFavChange:(val){
                                    if(BlocProvider.of<LoginBloc>(context).isLogged())
                                      favbloc.changeFavoriteState(val,detail.Id);
                                    else
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => ParentAuthPage()));
                                  },value: detail.IsFavorite,)),
                              SizedBox(width:20,),
                              GestureDetector(
                                onTap: () async {
                                  await FlutterShare.share(
                                      title: 'Taswiq share',
                                      text: detail.ArabicDescription,
                                      linkUrl: detail.ArabicDescriptionUrl,
                                      chooserTitle: 'taswiq Chooser Title');
                                }                ,
                                child: Container(
                                   // margin:EdgeInsets.only(top: 300 ,left:50,right: 50),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.share,
                                      size: 30.0,
                                      color: Colors.black,
                                    )),
                              ),
                            ],

                          ),
                        ),
                      ),


                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),

                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildDetailWidgets(detail)),
                    ),
                  ],
                );

                break;
              case Status.ERROR:
                return Center(
                  child: Text(allTranslations.text('err_wrong')),
                );

                break;
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget gettSliderImageWidget(List<AdvertismentImage> items) {
    if (items != null && items.length > 0)
      return Container(
          height: 320.0,
          width: double.infinity,
          child: CarouselSlider.builder(
            itemCount: items.length,
            enableInfiniteScroll: false,
            height: 400.0,
            aspectRatio: 1,
            viewportFraction: 1.0,

            itemBuilder: (context, index) {
/*
            if(items[index].base64Image == null &&
                items[index].isLoading == null)
              BlocProvider.of<DetailBloc>(context).GetImage(index,
                  items[index].Url);*/

              return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.green),
                  child: GestureDetector(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            Image.asset("images/logo.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset("images/logo.png"),
                        imageUrl: APIConstants.getFullImageUrl(
                            items[index].Url, ImageType.ADS),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(bloc:_bloc ,child: SliderFullImageViewer())
                                ,settings: RouteSettings(arguments:{"list":items,"index":index,"length":items.length})));



                      }));
            },
          ));
    else
      return Container(
        height: 250.0,
        child: Center(
            child: Icon(
          Icons.image,
          size: 100,
        )),
      );
  }

  List<Widget> _buildDetailWidgets(AdsDetail detail) {
    List<Widget> widgets = [];
    final title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            allTranslations.isEnglish ? detail.EnglishTitle : detail.ArabicTitle,
            style: TextStyle(fontSize: 18),maxLines: 3,
          ),
        ),
        Text(
          detail.Price == null ? "" : '${detail.Price} ج.م',
          style: TextStyle(fontSize: 20, color: Colors.green),
        )
      ],
    ); //title and price
    final viewCount = Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 40,
      decoration: BoxDecoration(color: Color(0xffe6e6e6)
      ,
      borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StreamBuilder(
              stream: _bloc.viewstream,
              builder: (context, snapshot) {
                Counter viewCounter = Counter(0, true);
                if (snapshot.hasData) viewCounter = snapshot.data;

                return Text(
                    "${allTranslations.text('view_count')}:${viewCounter.count.toString()}");
              }),
          Text("${allTranslations.text('id')}: ${detail.Id}")
        ],
      ),
    );
    widgets.add(title);
    widgets.add(SizedBox(
      height: 8,
    ));
    widgets.add(viewCount);
    widgets.add(SizedBox(
      height: 8,
    ));

    for (var spec in detail.Advertisment_Specification) {
      if (spec.AdvertismentSpecificatioOptions != null &&
          spec.AdvertismentSpecificatioOptions.length > 0) {
        String value = "";
        for (var option in spec.AdvertismentSpecificatioOptions) {
          value += allTranslations.isEnglish?option.NameEnglish.toString():option.NameArabic.toString();
        }

        widgets.add(Text(
          "${allTranslations.isEnglish?spec.NameEnglish:spec.NameArabic}:$value",
          textAlign: TextAlign.end,
        ));
        widgets.add(SizedBox(
          height: 8,
        ));
      } else {
        if (spec.CustomValue != null) {
          widgets.add(Text(
            "${allTranslations.isEnglish?spec.NameEnglish:spec.NameArabic}:${spec.CustomValue}",
            textAlign: TextAlign.end,
          ));
          widgets.add(SizedBox(
            height: 8,
          ));
        }
      }
    }
    widgets.add(Row(
      children: [
        Expanded(
          child: AutoDirection(
            text: allTranslations.isEnglish ? detail.EnglishDescription : detail.ArabicDescription,
            child: Text(
                "${allTranslations.isEnglish ? detail.EnglishDescription : detail.ArabicDescription}",

            ),
          ),
        ),
      ],
    ));
    widgets.add(SizedBox(
      height: 8,
    ));

    widgets.add(Text(
        "${allTranslations.isEnglish ? detail.StateNameEnglish : detail.StateNameArabic}"));
    final actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

    FlatButton.icon(onPressed: (){
      navigateTo(detail.LocationLatitude,detail.LocationLongtude);

    }, icon: Icon(Icons.map,color: Colors.green,), label: Text(allTranslations.text('map'))),
        FlatButton.icon(onPressed: null, icon:  Icon(Icons.flag,color: Colors.red,), label: Text(allTranslations.text('report')))


    ],
    );
    widgets.add(actions);
    widgets.add(SizedBox(
      height: 60,
    ));
/*
    widgets.add(
        Text("${detail.UserName == null ? "Anonymous" : detail.UserName}"));*/

    return widgets;
  }

  Widget getMapWidget(LatLng latLng) {
    return MapWidget(
      center: latLng,
      mapController: _mapController,
      onMapCreated: _onMapCreated,
      markers: _markers,
      onTap: (LatLng latLng) {},
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _textMe() async {
    if (Platform.isAndroid) {
      String uri = 'sms:${detailArgs.UserPhone}?body=hello%20there';
      await launch(uri);
    } else if (Platform.isIOS) {
      // iOS
      String uri = 'sms:${detailArgs.UserPhone}&body=hello%20there';
      await launch(uri);
    }
  }

   void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
