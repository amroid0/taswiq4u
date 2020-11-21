import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/detail_bloc.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/ads_detail.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/pages/edit_page.dart';
import 'package:olx/pages/slider_full+image_viewer.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/favroite_widget.dart';
import 'package:olx/widget/map_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_viewer_page.dart';

class DetailPage extends StatefulWidget {
 bool isEditable;


 DetailPage(this.isEditable);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailBloc _bloc;
  GoogleMapController _mapController;

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
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () {
            _makePhoneCall('tel:${detailArgs.UserPhone}');
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.black,
        ),
        body: StreamBuilder<ApiResponse<AdsDetail>>(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(
                  child: CircularProgressIndicator(),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffECECEC).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4)),
                                child:FavroiteWidget(onFavChange:(val){
            favbloc.changeFavoriteState(val,detail.Id);
            },value: true,)),



                            SizedBox(
                              width: 8,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffECECEC).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Icon(
                                  Icons.share,
                                  size: 30.0,
                                  color: Colors.black,
                                )),
                            Visibility(
                              visible: widget.isEditable,
                              child: GestureDetector(

                                onTap: (){

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => BlocProvider(bloc: AdsBloc(),child:EditPage(),),
                                          settings: RouteSettings(arguments:detail)

                                      ));






                                },
                                child: Container(

                                    decoration: BoxDecoration(
                                        color: Color(0xffECECEC).withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(4)),
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
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            tooltip: 'back',
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
                        fit: BoxFit.cover,
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
                                ,settings: RouteSettings(arguments:{"list":items,"index":index})));



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
        Text(
          allTranslations.isEnglish ? detail.EnglishTitle : detail.ArabicTitle,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          detail.Price == null ? "" : detail.Price.toString(),
          style: TextStyle(fontSize: 20, color: Colors.green),
        )
      ],
    ); //title and price
    final viewCount = Container(
      height: 40,
      decoration: BoxDecoration(color: Color(0xffe6e6e6)),
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
          value += option.NameEnglish.toString();
        }

        widgets.add(Text(
          "${spec.NameArabic}:$value",
          textAlign: TextAlign.end,
        ));
        widgets.add(SizedBox(
          height: 8,
        ));
      } else {
        if (spec.CustomValue != null) {
          widgets.add(Text(
            "${spec.NameArabic}:${spec.CustomValue}",
            textAlign: TextAlign.end,
          ));
          widgets.add(SizedBox(
            height: 8,
          ));
        }
      }
    }
    widgets.add(Text(
        "${allTranslations.isEnglish ? detail.EnglishDescription : detail.ArabicDescription}"));
    widgets.add(SizedBox(
      height: 8,
    ));

    widgets.add(Text(
        "${allTranslations.isEnglish ? detail.StateNameEnglish : detail.StateNameArabic}"));

    widgets.add(getMapWidget(LatLng(
        detail.LocationLatitude != null
            ? detail.LocationLatitude.toDouble()
            : 0,
        detail.LocationLongtude != null
            ? detail.LocationLongtude.toDouble()
            : 0)));
    widgets.add(SizedBox(
      height: 8,
    ));

    widgets.add(
        Text("${detail.UserName == null ? "Anonymous" : detail.UserName}"));

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
}
