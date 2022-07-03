import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olx/data/bloc/Post_Report_bloc.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/detail_bloc.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/Post_Report_entity.dart';
import 'package:olx/model/ads_detail.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/pages/edit_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/slider_full+image_viewer.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/ToastUtils.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/favroite_widget.dart';
import 'package:olx/widget/map_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  AdsReportBloc _reportBloc;

  final detailScaffoldMessengerKey = GlobalKey<ScaffoldState>();

  final Set<Marker> _markers = {};
  AdsModel detailArgs;

  FavroiteBloc favbloc;

  AdsDetail detail;
  PostReport _postReport;

  List<String> reportReasons = [
    allTranslations.text('report_ressons1'),
    allTranslations.text('report_ressons2'),
    allTranslations.text('report_ressons3'),
    allTranslations.text('report_ressons4'),
    allTranslations.text('report_ressons5')
  ];
  String _select_Types;

  bool reportDiolag = false;

  TextEditingController message = TextEditingController();

  ArsProgressDialog progressDialog;

  @override
  void initState() {
    // TODO: implement initState
    _bloc = DetailBloc();
    _reportBloc = AdsReportBloc();

    favbloc = new FavroiteBloc();

    favbloc.stateStream.listen((data) {
      // Redirect to another view, given your condition

      switch (data.status) {
        case Status.LOADING:
          break;

        case Status.ERROR:
          break;
        case Status.COMPLETED:
          // TODO: Handle this case.
          var isLogged = data as ApiResponse<bool>;
          var isss = isLogged.data;
          if (isss) {
            /*       Fluttertoast.showToast(
                msg: "Favorite",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );*/
          } else {
            /*      Fluttertoast.showToast(
                msg: "UnFavorite",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );*/

          }
          break;
      }
    });

    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    _bloc.deleteStateStream.listen((snap) {
      if (progressDialog.isShowing) {
        progressDialog.dismiss();
      }
      switch (snap.status) {
        case Status.LOADING:
          progressDialog.show();
          break;

        case Status.ERROR:
          ToastUtils.showErrorMessage(allTranslations.text('err_wrong'));

          break;

        case Status.COMPLETED:
          ToastUtils.showSuccessMessage(
              allTranslations.text('success_delete_ads'));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<AdsBloc>(context).getMyAdsListe(1);
            Navigator.pop(context);
          });

          break;
      }
    });
    _bloc.distnictStateStream.listen((snap) {
      if (progressDialog.isShowing) {
        progressDialog.dismiss();
      }
      switch (snap.status) {
        case Status.LOADING:
          progressDialog.show();
          break;

        case Status.ERROR:
          ToastUtils.showErrorMessage(allTranslations.text('err_wrong'));

          break;

        case Status.COMPLETED:
          ToastUtils.showSuccessMessage(
              allTranslations.text('success_distincit_ads'));

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
        floatingActionButton: SpeedDial(
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
              child: Icon(
                Icons.textsms,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
              label: allTranslations.text('conversation'),
              labelBackgroundColor: Colors.white,
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => _textMe(),
              onLongPress: () => print('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(
                Icons.call,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
              label: allTranslations.text('calling'),
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: Colors.white,
              onTap: () {
                _makePhoneCall('tel:${detailArgs.UserPhone}');
              },
              onLongPress: () => print('SECOND CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(
                Icons.copy,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
              label: allTranslations.text('copy_num'),
              labelBackgroundColor: Colors.white,
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => Clipboard.setData(
                      new ClipboardData(text: detailArgs.UserPhone))
                  .then((_) {
                detailScaffoldMessengerKey.currentState.showSnackBar(SnackBar(
                    content: Text(allTranslations.text('copied_num'))));
              }),
              onLongPress: () => print('THIRD CHILD LONG PRESS'),
            ),
          ],
        ),
        body: StreamBuilder<ApiResponse<AdsDetail>>(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null)
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Container(
                  child: Center(child: CircularProgressIndicator()),
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
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: AlignmentDirectional.topStart,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffa49399),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                width: 45,
                                height: 45,
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Color(0xffa49399),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: FavroiteWidget(
                                  onFavChange: (val) {
                                    if (BlocProvider.of<LoginBloc>(context)
                                        .isLogged())
                                      favbloc.changeFavoriteState(
                                          val, detail.Id);
                                    else
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ParentAuthPage()));
                                  },
                                  value: detail.IsFavorite,
                                  bgColor:  Color(0xffa49399),
                                    iconColor: Colors.white
            ,
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await FlutterShare.share(
                                    title: 'Taswiq share',
                                    linkUrl: detail.TextShareEn,
                                    chooserTitle: 'taswiq Chooser Title');
                              },
                              child: Container(
                                  width: 45,
                                  height: 45,
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xffa49399),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.share,
                                    size: 30.0,
                                    color: Colors.white,
                                  )),
                            ),
                          /*  Visibility(
                              visible: true*//*widget.isEditable*//*,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                                bloc: AdsBloc(),
                                                child: EditPage(detail),
                                              ),
                                          settings: RouteSettings(
                                              arguments: detail)));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xffECECEC).withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.edit,
                                      size: 30.0,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: true*//*widget.isEditable*//*,
                              child: GestureDetector(
                                onTap: () {
                                  _bloc.deleteAds(detail.Id.toString());
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xffECECEC).withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.delete,
                                      size: 30.0,
                                      color: Colors.red,
                                    )),
                              ),
                            ),*/
                            SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible:widget.isEditable,
                              child: GestureDetector(
                                onTap: () {
                                  _bloc.distinictAds(detail.Id.toString());
                                },
                                child: Container(
                                    width: 45,
                                    height: 45,
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffa49399),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.star,
                                      size: 30.0,
                                      color: Colors.amber,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
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
                                builder: (context) => BlocProvider(
                                    bloc: _bloc,
                                    child: SliderFullImageViewer()),
                                settings: RouteSettings(arguments: {
                                  "list": items,
                                  "index": index,
                                  "length": items.length
                                })));
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
    final title = Column(
      children: <Widget>[
        Align(alignment: AlignmentDirectional.topStart,
          child: Text(
            allTranslations.isEnglish
                ? detail.EnglishTitle
                : detail.ArabicTitle,
            style: TextStyle(fontSize: 16,color: Color(0xff2D3142),fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              detail.Price == null
                  ? ""
                  : '${detail.Price}  ${allTranslations.text('cuurency')}',
              style: TextStyle(fontSize: 16, color: Color(0xff53B553),fontWeight: FontWeight.bold),
            ),
            Text(
              detail.CreationTime == null
                  ? ""
                  : '${detail.CreationTime}}',
              style: TextStyle(fontSize: 11, color: Color(0xff818391)),
            ),
          ],
        ),
        SizedBox(height: 8,),
        Divider(color: Colors.black.withOpacity(.16),),
        SizedBox(height: 8,),

        Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
          children: [
            Text(
                "${allTranslations.isEnglish ? detail.StateNameEnglish : detail.StateNameArabic}",style: TextStyle(color:Color(0xff818391),fontSize: 11),),

               InkWell(
                 onTap: (){
                   navigateTo(detail.LocationLatitude, detail.LocationLongtude);
                 },
                 child: Icon(Icons.directions,color: AppColors.accentColor,),
               )
          ],
        ),
        SizedBox(height: 8,),
        Divider(color: Colors.black.withOpacity(.16),),
        SizedBox(height: 16,),



      ],
    ); //title and price
    /*final viewCount = Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 40,
      decoration: BoxDecoration(
          color: Color(0xffe6e6e6), borderRadius: BorderRadius.circular(10)),
      *//*child: Row(
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
      ),*//*
    );*/
    widgets.add(title);
    widgets.add(SizedBox(
      height: 8,
    ));
  //  widgets.add(viewCount);

    widgets.add(Text(allTranslations.text("properties"),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));

    bool isEvenRow = true;

    for (var spec in detail.Advertisment_Specification) {
      if (spec.AdvertismentSpecificatioOptions != null &&
          spec.AdvertismentSpecificatioOptions.length > 0) {
        String value = "";
        for (var option in spec.AdvertismentSpecificatioOptions) {
          value += allTranslations.isEnglish
              ? option.NameEnglish.toString()
              : option.NameArabic.toString();
        }

        widgets.add(ListTile(
          tileColor:Color(0xffF6F8FA),
          dense: true,
          leading: Text(
            allTranslations.isEnglish ? spec.NameEnglish : spec.NameArabic,
            style: TextStyle(fontSize: 14,color: Color(0xff2D3142)),
          ),
          trailing: Text(value,style: TextStyle(fontSize: 14,color: Color(0xff2D3142))),
        ));
        widgets.add(Container(
            color:Color(0xffF6F8FA),
            child: Divider(color: Color(0x1A818391),)));
      } else {
        if (spec.CustomValue != null) {
          widgets.add(ListTile(
            tileColor:Color(0xffF6F8FA),
            leading: Text(
                "${allTranslations.isEnglish ? spec.NameEnglish : spec.NameArabic}",
              style: TextStyle(fontSize: 14,color: Color(0xff2D3142))),
            trailing: Text(
              "${spec.CustomValue}",style: TextStyle(fontSize: 14,color: Color(0xff2D3142))
            ),
          ));
          widgets.add(Container(            color:Color(0xffF6F8FA),
              child: Divider(color: Color(0x1A818391),)));

        }
      }
      isEvenRow = !isEvenRow;
    }
    widgets.add(SizedBox(
      height: 8,
    ));
    widgets.add(Text(allTranslations.text('details'),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
    widgets.add(Row(
      children: [
        Expanded(
          child: StreamBuilder<bool>(
              stream: _bloc.translatestream,
              initialData: false,
              builder: (ctx, snap) {
                String text = allTranslations.isEnglish
                    ? !snap.data
                        ? detail.EnglishDescription
                        : detail.ArabicDescription
                    : !snap.data
                        ? detail.ArabicDescription
                        : detail.EnglishDescription;
                return AutoDirection(
                  text: text,
                  child: Text(
                    "$text",
                  ),
                );
              }),
        ),
      ],
    ));
    widgets.add(SizedBox(
      height: 16,
    ));



    final actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
   FlatButton.icon(
        onPressed: () {
      _bloc.translateAds();
    },
    icon: Icon(
    Icons.translate,
    color: Colors.blueAccent,
    ),
    label: Text(allTranslations.text('translate'))),
        FlatButton.icon(
            onPressed: () {
              // setState(() {
              //   reportDiolag = true ;
              // });
              Alert(
                  context: context,
                  title: allTranslations.text('report'),
                  content: StatefulBuilder(
                    builder: (BuildContext context,
                            void Function(void Function()) setState) =>
                        Container(
                      child: Column(children: <Widget>[
                        DropdownButton<String>(
                          hint: Text(
                            allTranslations.text('reason'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: _select_Types,
                          onChanged: (String Value) {
                            setState(() {
                              _select_Types = Value;
                            });
                          },
                          items: reportReasons.map((String types) {
                            return DropdownMenuItem<String>(
                              value: types,
                              child: Row(
                                children: <Widget>[
                                  reportReasons.length > 0
                                      ? Text(
                                          types,
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : Text(
                                          'no data',
                                          style: TextStyle(color: Colors.black),
                                        )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white10.withOpacity(0.5)),
                          height: 100,
                          //  color:Colors.black12,
                          margin: EdgeInsets.all(20),

                          child: TextField(
                              controller: message,
                              decoration: new InputDecoration(
                                labelText: allTranslations.text('message'),
                                labelStyle: TextStyle(color: Colors.black),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                              )),
                        ),
                      ]),
                    ),
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context).isLogged()
                            ? _reportBloc.adsReport(
                                PostReport(
                                    countryId: 1,
                                    adId: detailArgs.Id,
                                    message: message.text,
                                    reason: _select_Types),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ParentAuthPage()));
                        _reportBloc.addStream.listen((data) {
                          switch (data.status) {
                            case Status.LOADING:
                              Future.delayed(Duration.zero, () {});
                              break;
                            case Status.COMPLETED:
                              var isLogged = data as ApiResponse<bool>;
                              var isss = isLogged.data;
                              if (isss) {
                                Fluttertoast.showToast(
                                    msg: allTranslations.text('send_success'),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pop(context);
                              }

                              break;
                            case Status.ERROR:
                              ToastUtils.showErrorMessage(
                                  allTranslations.text('err_wrong'));
                              break;
                          }
                        });
                      },
                      child: Text(
                        allTranslations.text('send'),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();
            },
            icon: Icon(
              Icons.flag,
              color: Colors.red,
            ),
            label: Text(allTranslations.text('report'))),
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

  bool AddReport() {
//     return Container(
//       margin:EdgeInsets.only(top:100),
//         child: Visibility(
//             visible: reportDiolag,
//             child: Card(
//               color: Colors.white,
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0)), //this right here
//               child: SingleChildScrollView(
//                 child: Container(
//                   height: MediaQuery.of(context).size.height*0.6,
//                   width: MediaQuery.of(context).size.width*0.7,
//                   child: Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(top: 0.0, left: 5.0),
//                               child: Text(
//                                 "Report Ads",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.35,
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 Icons.clear,
//                                 size: 25,
//                                 color:Colors.green ,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   reportDiolag = false ;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         SingleChildScrollView(
//                           padding: EdgeInsetsDirectional.only(start: 5.0),
//                           child: Column(
//                               crossAxisAlignment:CrossAxisAlignment.center ,
//                               mainAxisAlignment:MainAxisAlignment.center ,
//                               children: [
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//
//                                 DropdownButton<String>(
//                                   hint:  Text("Reason", style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                   ),),
//                                   value: _select_Types,
//                                   onChanged: (String Value) {
//                                     setState(() {
//                                       // _departmentSelected.type="";
//                                       _select_Types = Value;
//                                     });
//                                   },
//                                   items: reportReasons.map((String types) {
//                                     return  DropdownMenuItem<String>(
//                                       value: types,
//                                       child: Row(
//                                         children: <Widget>[
//                                           reportReasons.length > 0  ? Text(
//                                             types,
//                                             style:  TextStyle(color: Colors.black),
//                                           )
//                                               : Text(
//                                             'no data',
//                                             style:  TextStyle(color: Colors.black),
//                                           )
//                                         ],
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                                 SizedBox(height: 20,),
//                                 Center(
//                                  child: Container(
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         color:Colors.white10.withOpacity(0.5)
//                                     ),
//                                     height: 100,
//                                     //  color:Colors.black12,
//                                     margin: EdgeInsets.all(20),
//
//                                     child: TextField(
//                                       controller:message,
//                                         decoration :  new InputDecoration(
//                                           labelText: 'Message',
//                                           labelStyle:TextStyle(color:Colors.black),
//                                           border: new OutlineInputBorder(
//                                             borderRadius: const BorderRadius.all(
//                                               const Radius.circular(8.0),
//                                             ),
//                                           ),
//                                         )),
//                                   ),
//                                 ),
//
//                                 SizedBox(
//                                   height:15,
//                                 ),
//                                 SizedBox(
//                                   height:MediaQuery.of(context).size.height*0.1 ,
//                                 ),
//                                 Align(
//                                     child: ElevatedButton(
//                                        child:Text('Send'),
//                                       onPressed:(){
//                                         if(BlocProvider.of<LoginBloc>(context).isLogged())
//                                           BlocProvider.of<AdsReportBloc>(context).adsReport(
//                                             PostReport(
//                                               countryId:1,
//                                               adId: 3,
//                                               message:message.text,
//                                               reason:_select_Types
//
//                                             )
//                                           );
//                                         else
//                                           Navigator.push(
//                                               context, MaterialPageRoute(builder: (context) => ParentAuthPage()));
//                                       },
//                                     )),
//
//                               ]
//                           ),
//                         ),
// //                              SizedBox(height: 20),
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )));
  }
}
