import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/ToastUtils.dart';
import 'package:olx/utils/global_locale.dart';
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
    bloc = OfferBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    result = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: new Scaffold(
        backgroundColor: Colors.black.withOpacity(.70),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.55,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.fill,
                    placeholder: 'images/logo.png',
                    image: APIConstants.getFullImageUrl(
                        result.systemDataFile1 != null
                            ? result.systemDataFile1.url
                            : "",
                        ImageType.COMMAD)),
              ),
            ),
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
                    result.description,
                    style: TextStyle(color: Color(0xff2D3142)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Row(children: <Widget>[
                        InkWell(
                            onTap: () {
                              //                                bloc.likeAds(true);
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              color: AppColors.accentColor,
                            )),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          result.viewsCount.toString(),
                          style: TextStyle(color: AppColors.accentColor),
                        ),
                      ]),
                      SizedBox(
                        width: 8,
                      ),
                      _buildLikeWidget(result),
                    ],
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            final url = result.phoneNumber;
                            if (await canLaunch('tel:$url'))
                              await launch('tel:$url');
                            else
                              // can't launch url, there is some error
                              ToastUtils.showErrorMessage("رقم الهاتف غير صحيح");
                          },
                          child: Container(
                              width: 38,
                              height: 38,
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFCAD1E0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: Icon(
                                MdiIcons.phoneInTalk,
                                color: Color(0xff0AB3FF),
                                size: 30,
                              ))),
                      SizedBox(
                        width: 12,
                      ),
                      InkWell(
                          onTap: () async {
                            var whatsappUrl =
                                "whatsapp://send?phone=${result.phoneNumber}";
                            await canLaunch(whatsappUrl)
                                ? launch(whatsappUrl)
                                : ToastUtils.showErrorMessage(
                                    "رقم الهاتف غير صحيح");
                          },
                          child: Container(
                              width: 38,
                              height: 38,
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFCAD1E0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: Icon(
                                MdiIcons.whatsapp,
                                color: AppColors.accentColor,
                                size: 30,
                              ))),
                      SizedBox(
                        width: 12,
                      ),
                      InkWell(
                          onTap: () async {
                            const url = "http://taswiq4u.com/";
                            if (await canLaunch(url))
                              await launch(url);
                            else
                              // can't launch url, there is some error
                              throw "Could not launch $url";
                          },
                          child: Container(
                              width: 38,
                              height: 38,
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFCAD1E0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: Icon(
                                Icons.language_outlined,
                                color: Color(0xff00E4F0),
                                size: 30,
                              ))),
                      SizedBox(
                        width: 12,
                      ),
                      InkWell(
                          onTap: () async {
                            final url = result.instagramLink;
                            if (await canLaunch(url))
                              await launch(url);
                            else
                              // can't launch url, there is some error
                              ToastUtils.showErrorMessage("اللينك غير صالح");
                          },
                          child: Container(
                              width: 38,
                              height: 38,
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFCAD1E0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: Icon(
                                MdiIcons.instagram,
                                color: Color(0xff7623BE),
                                size: 30,
                              ))),
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[]),
            )
        ],
      ),
          )),
    );
  }

  Widget _buildLikeWidget(PopupAdsEntityList item) {
    return StreamBuilder<Counter>(
      initialData: Counter(item.likes, item.isLiked),
      stream: bloc.Likestream,
      builder: (context, snapshot) {
        Counter likeCounter = Counter(0, false);
        if (snapshot.hasData) likeCounter = snapshot.data;
        else if(snapshot.hasError){
          ToastUtils.showWarningMessage(allTranslations.text('ensure_login'));

        }
        return Row(children: <Widget>[
          InkWell(
              onTap: () {
                if (!likeCounter.isLiked) bloc.likePopUpAds(result, true);
              },
              child: Icon(
                likeCounter.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                color: AppColors.accentColor,
              )),
          SizedBox(
            width: 4,
          ),
          Text(
            likeCounter.count.toString(),
            style: TextStyle(color: AppColors.accentColor),
          ),
        ]);
      },
    );
  }
}
