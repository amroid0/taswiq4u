import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/pages/detail_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/favorite_card.dart';
import 'package:olx/widget/favroite_widget.dart';

class AdsRowWidget extends StatelessWidget {
  AdsModel model;
  int language ;
  final bool editable;
  AdsRowWidget({this.model,this.language,this.editable});




  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(right:4.5,left:4.5,bottom:0.25,),
      child: Container(

        margin: const EdgeInsets.only(right:4.5,left:4.5,bottom:0.25,),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  // builder: (context) => DetailPage(editable)
                  // ,settings: RouteSettings(arguments: model),
                  builder: (context) => DetailPage(false)
                  ,settings: RouteSettings(arguments: model)),);

          },
          child: new Card(
            elevation: 2,
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



                        child: ClipRRect(
                          borderRadius:BorderRadius.circular(20) ,
                          child:
                            (model.AdvertismentImages.isNotEmpty&&model.AdvertismentImages[0].Url!=null&&model.AdvertismentImages[0].Url.isNotEmpty)?


                  CachedNetworkImage(
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Image.asset("images/logo.png"),
                            errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                            imageUrl: APIConstants.getFullImageUrl(model.AdvertismentImages.isEmpty?"":model.AdvertismentImages[0].Url,ImageType.ADS),
                          ):      Image.asset("images/logo.png",fit: BoxFit.fill,)
                  ,
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
                              ),),
                              Text(language==1 ? "${model.Price}  ${allTranslations.text('cuurency')}" :"${model.Price}  ${allTranslations.text('cuurencyKd')}" ,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,

                                style: TextStyle(color: Theme
                                    .of(context)
                                    .accentColor),),
                              SizedBox(height: 4,),
                              Divider(height: 1,color: Colors.grey.shade500,thickness: 1,),
                              SizedBox(height: 4,),

                              Row(

                                children: <Widget>[
                                  Icon(Icons.pin_drop_outlined, size: 20,),
                                  Text(allTranslations.isEnglish ?model.CityNameEnglish :model.CityNameArabic, style: Theme.of(context).textTheme.bodyText2),

                                ],),
                              SizedBox(height: 4,),

                              Row(
                                children: <Widget>[
                                  Icon(Icons.update_outlined, size: 20,),

                                  FittedBox(
                                    child: Text( displayTimeAgoFromTimestamp(model.CreationTime),
                                      style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ),


                                ],),


                            ],

                          ),
                        )


                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(

                          onTap: () {},
                          child: Container(
                              margin: EdgeInsets.only(left: 4),

                              alignment: Alignment.center,
                              color: Colors.white,
                              child: FavroiteWidgetCard(
                                  onFavChange:(val){
                                    if(BlocProvider.of<LoginBloc>(context).isLogged())
                                      BlocProvider.of<FavroiteBloc>(context).changeFavoriteState(val,model.Id);
                                    else
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => ParentAuthPage()));                          },
                                  value: (BlocProvider.of<LoginBloc>(context).isLogged())?model.IsFavorite:false
                              )

                          ),
                        ),
                      ],
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
