import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/pages/detail_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/favorite_card.dart';
import 'package:olx/widget/favroite_widget.dart';
import 'package:olx/widget/star_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdsRowWidget extends StatelessWidget {
  AdsModel model;
  int language ;
  final bool editable;
  final AdsBloc bloc;

  Radius imageRadius;
  AdsRowWidget({this.model,this.language,this.editable=false,this.bloc});




  @override
  Widget build(BuildContext context) {
 imageRadius=  Radius.circular(12);
    return Padding(
      padding: const EdgeInsets.only(right:4.5,left:4.5,bottom:12,),
      child: Container(

        margin: const EdgeInsets.only(right:4.5,left:4.5,bottom:0.25,),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  // builder: (context) => DetailPage(editable)
                  // ,settings: RouteSettings(arguments: model),
                  builder: (context) => BlocProvider(bloc:bloc,child: DetailPage(editable??false))
                  ,settings: RouteSettings(arguments: model)),);

          },
          child: new Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: new Container(



              child: IntrinsicHeight(
                child:  Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(20) ,
                            color: Colors.grey.shade300
                        ),



                        child: Stack(
                          fit: StackFit.expand,
                          children: [ClipRRect(
                            borderRadius:allTranslations.isEnglish?BorderRadius.only(topLeft: imageRadius,bottomLeft: imageRadius):BorderRadius.only(topRight: imageRadius,bottomRight: imageRadius) ,
                            child:
                            (model.AdvertismentImages.isNotEmpty&&model.AdvertismentImages[0].Url!=null&&model.AdvertismentImages[0].Url.isNotEmpty)?


                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Image.asset("images/logo.png"),
                              errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                              imageUrl: APIConstants.getFullImageUrl(model.AdvertismentImages.isEmpty?"":model.AdvertismentImages[0].Url,ImageType.ADS),
                            ):      Image.asset("images/logo.png",fit: BoxFit.fill,)
                            ,
                          ),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: editable?  StarWidget(
                                    onFavChange:(val){
                                      if(BlocProvider.of<LoginBloc>(context).isLogged())
                                        Alert(
                                          context: context,
                                          title: allTranslations.text('feature'),
                                          desc: allTranslations.text('feature_msg'),
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
                                                BlocProvider.of<AdsBloc>(context).distinictAds(model.Id.toString());

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

                                      else
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => ParentAuthPage()));

                                      },
                                    value: (BlocProvider.of<LoginBloc>(context).isLogged())?model.IsFeatured:false
                                ): FavroiteWidget(
                                    onFavChange:(val){
                                      if(BlocProvider.of<LoginBloc>(context).isLogged())
                                        BlocProvider.of<FavroiteBloc>(context).changeFavoriteState(val,model.Id);
                                      else
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => ParentAuthPage()));                          },
                                    value: (BlocProvider.of<LoginBloc>(context).isLogged())?model.IsFavorite:false
                                ),
                              ),
                            ),
                          ]
                        )
                    ),


                    new Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 18),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(model.EnglishTitle,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(
                                height: 1.2,
                                color: Color(0xff2D3142),
                                fontSize: 14
                              ),),
                              Text(language==1 ? "${model.Price}  ${allTranslations.text('cuurency')}" :"${model.Price}  ${allTranslations.text('cuurencyKd')}" ,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,

                                style: TextStyle(
                                  color: Color(0xff2D3142),
                                  fontWeight: FontWeight.bold
                                ),),
                              SizedBox(height: 4,),
                              SizedBox(height: 4,),

                              Row(

                                children: <Widget>[
                                  //Icon(Icons.pin_drop_outlined, size: 20,),
                                  FittedBox(
                                    child: Text( displayTimeAgoFromTimestamp(model.CreationTime),
                                      style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 11 ,color: AppColors.secondaryTextColor),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ),
                                  Text(" - ",style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 11 ,color: AppColors.secondaryTextColor),),
                                  Text(allTranslations.isEnglish ?model.CityNameEnglish :model.CityNameArabic, style:Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 11 ,color: AppColors.secondaryTextColor)),

                                ],),
                              SizedBox(height: 4,),




                            ],

                          ),
                        )


                    ),



                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  static String displayTimeAgoFromTimestamp(DateTime dateString, {bool numericDates = true}) {
    final date2 = DateTime.now();
    print(date2);
    print(dateString);
    final difference = date2.difference(dateString);
    print(difference);

    if (difference.inDays > 10) {

      return '${(dateString.day)} / ${(dateString.month)} ' ;
    }  else if (difference.inDays >= 2) {
      return '${difference.inDays} ${allTranslations.text('days_ago')}';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? ' 1 ${allTranslations.text('day_ago')}' : ' ${allTranslations.text('yestrday')}';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}${allTranslations.text('hours_ago')}';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '${allTranslations.text('hour_ago')}' : '${allTranslations.text('hour_ago')}';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes}${allTranslations.text('minutes_ago')}';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1${allTranslations.text('minute_ago')}' : '${allTranslations.text('minute_ago')}';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ${allTranslations.text('seconds_ago')}';
    } else {
      return '${allTranslations.text('now')}';
    }
  }


}
