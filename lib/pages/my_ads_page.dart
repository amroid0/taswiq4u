import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/ToastUtils.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/ads_widget_card.dart';
import 'package:olx/widget/ads_widget_row.dart';
import 'package:olx/widget/favroite_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'edit_page.dart';

class MyAdsPage extends StatefulWidget {
  @override
  _MyAdsPageState createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  int _sortSelectedValue = 1;
  ScrollController _scrollController = new ScrollController();
  int page = 1;
  List<AdsModel> ads;
  int lang;
  String countryId;

  var _gridItemCount = 1;
  var bloc;
  AdsBloc _bloc = AdsBloc();

  ArsProgressDialog progressDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    getGroupId();
    bloc = new FavroiteBloc();
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
            _bloc.getMyAdsListe(1);
          });

          break;
      }
    });
    _bloc.featureStateStream.listen((data) {
      // Redirect to another view, given your condition

      switch (data.status) {
        case Status.LOADING:
          break;

        case Status.ERROR:
          ToastUtils.showErrorMessage(
              allTranslations.text('not_allowed_feature'));

          break;
        case Status.COMPLETED:
          // TODO: Handle this case.
          var isLogged = data as ApiResponse<bool>;
          var isss = isLogged.data;
          if (isss) {
            Fluttertoast.showToast(
                msg:  allTranslations.text('success_distincit_ads'),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
                fontSize: 16.0
            );
              _bloc.getMyAdsListe(1);

          }else{

            Fluttertoast.showToast(
                msg: "unFeatured",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          break;
      }
    });

    _bloc.getMyAdsListe(1);

    _scrollController.addListener(() {
      var isLoadMore;
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          isLoadMore == null) {
        //todo paging
        /*    if(ads.advertisementList.page==1)
          BlocProvider.of<AdsBloc>(context).submitQuery(params
              ,_sortSelectedValue,2);
          else if(ads.advertisementList.hasNextPage)
        BlocProvider.of<AdsBloc>(context).submitQuery(params,
            _sortSelectedValue,ads.advertisementList.nextPage);
*/

      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // BlocProvider.of<AdsBloc>(context).dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  appBar=
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.black,
                size:35,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'back',
            ),
          ],
        ),
        title: Text(
          'My Ads',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),

        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        // actions: <Widget>[
        //
        // ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<ApiResponse<List<AdsModel>>>(
              stream: _bloc.myAdsstream,
              builder: (context, snap) {
                if (snap.data != null)
                  switch (snap.data.status) {
                    case Status.LOADING:
                      if (page == 1)
                        return new Center(
                          child: new CircularProgressIndicator(
                            backgroundColor: Colors.deepOrangeAccent,
                            strokeWidth: 5.0,
                          ),
                        );

                      break;

                    case Status.COMPLETED:
                      ads = snap.data.data as List<AdsModel>;
                      return BlocProvider(
                          bloc: _bloc, child: _buildAdsList(ads));
                      break;
                    case Status.ERROR:
                      return EmptyListWidget(
                          title: 'Error',
                          subTitle: 'Something Went Wrong',
                          image: 'images/error.png',
                          titleTextStyle: Theme.of(context)
                              .typography
                              .dense
                              .display1
                              .copyWith(color: Color(0xff9da9c7)),
                          subtitleTextStyle: Theme.of(context)
                              .typography
                              .dense
                              .body2
                              .copyWith(color: Color(0xffabb8d6)));
                      break;
                  }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAdsList(List<AdsModel> ads) {
    if (ads.isEmpty)
      return EmptyListWidget(
          title: 'Empty Ads',
          subTitle: 'No  Ads available yet',
          image: 'images/ads_empty.png',
          titleTextStyle: Theme.of(context)
              .typography
              .dense
              .display1
              .copyWith(color: Color(0xff9da9c7)),
          subtitleTextStyle: Theme.of(context)
              .typography
              .dense
              .body2
              .copyWith(color: Color(0xffabb8d6)));
    else if (_gridItemCount == 2)
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _gridItemCount,
            childAspectRatio: 0.68,
          ),
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: ads.length,
          itemBuilder: (BuildContext context, int index) {
            int adsIndex = index;

            if (ads[adsIndex] == null) {
              return _buildLoaderListItem();
            } else {
              return AdsCardWidget(
                model: ads[adsIndex],
                editable: true,
                language: lang,
                bloc: _bloc,
              );
            }
          });
    else
      return ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: ads.length,
          itemBuilder: (BuildContext context, int index) {
            int adsIndex = index;

            if (ads[adsIndex] == null) {
              return _buildLoaderListItem();
            } else {
              List<AdvertismentImage> imageList =
                  ads[adsIndex].AdvertismentImages;

              return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: allTranslations.text('edit'),
                      color: Colors.green,
                      icon: FontAwesomeIcons.edit,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      bloc: AdsBloc(),
                                      child: EditPage(ads[adsIndex]),
                                    ),
                                settings:
                                    RouteSettings(arguments: ads[adsIndex])));
                      },
                    ),
                    IconSlideAction(
                      caption: allTranslations.text('delete'),
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        _bloc.deleteAds(ads[adsIndex].Id.toString());
                      },
                      onTap:(){
                        Alert(
                          context: context,
                          title: allTranslations.text('delete'),
                          desc: allTranslations.text('delete_msg'),
                          style: AlertStyle(
                            isCloseButton: false,
                            alertBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          buttons: [
                            DialogButton(
                              radius: BorderRadius.all(Radius.circular(20)),
                              child: Text(
                                allTranslations.text('ok'),
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                _bloc.deleteAds(ads[adsIndex].Id.toString());

                              },
                              width: 120,
                              height: 56,
                            ),
                            DialogButton(
                              radius: BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                width: 120,
                                height: 56,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(
                                      color: AppColors.accentColor,
                                      width: 1,
                                    )),
                                child: Center(
                                  child: Text(
                                    allTranslations.text('cancel'),
                                    style: TextStyle(
                                        color: AppColors.accentColor, fontSize: 20),
                                  ),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                              height: 56,
                              color: Colors.white,
                            )
                          ],
                        ).show();

                      } ,
                    ),
                  ],
                  child: AdsRowWidget(
                    model: ads[adsIndex],
                    editable: true,
                    language: lang,
                    bloc: _bloc,
                  ));
            }
          });
  }

  Widget _buildLoaderListItem() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void getGroupId() async {
    var user = await preferences.getUserInfo();
    lang = user.countryId;
    print("group  value" + lang.toString());
  }
}
