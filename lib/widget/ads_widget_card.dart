import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
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


class AdsCardWidget extends StatelessWidget {
  AdsModel model;
  int language ;
  final bool editable;
  final Bloc bloc;
  AdsCardWidget({this.model,this.editable=false,this.language,this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:2.0, right:2.0 , top:1.0,bottom: 1.0),
      child: Container(

        margin: const EdgeInsets.all(2),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(bloc:bloc,child: DetailPage(editable))
                  , settings: RouteSettings(arguments: model)),
            );
          },
          child: new Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            child: new SizedBox(
              height: 220,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  new Container(
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),

                          color: Colors.grey.shade300

                      ),
                      child: Stack(
                fit: StackFit.expand,
                children: [
                    ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                          child: _BuildImageWidget()),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child:editable?  StarWidget(
                          onFavChange:(val){
                            if(BlocProvider.of<LoginBloc>(context).isLogged())
                              BlocProvider.of<AdsBloc>(context).distinictAds(model.Id.toString());
                            else
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => ParentAuthPage()));                          },
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


                ])
                  ),

                  new Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 2),
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
    );;
  }

  Widget _BuildImageWidget() {
    if (model.AdvertismentImages.isNotEmpty &&
        model.AdvertismentImages[0].Url != null &&
        model.AdvertismentImages[0].Url.isNotEmpty)
      return CachedNetworkImage(
        fit: BoxFit.fill,
        placeholder: (context, url) => Image.asset("images/logo.png"),
        errorWidget: (context, url, error) => Image.asset("images/logo.png"),
        imageUrl: APIConstants.getFullImageUrl(
            model.AdvertismentImages[0].Url, ImageType.ADS),
      );
    else
      return Image.asset("images/logo.png", fit: BoxFit.fill,);
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
      return '${difference.inDays} ${allTranslations.text('day_sago')}';
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