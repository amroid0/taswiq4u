import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/pages/detail_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/favroite_widget.dart';


class AdsCardWidget extends StatelessWidget {
  AdsModel model;
  final bool editable;

  AdsCardWidget(this.model,{this.editable=false});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.all(4),
      child: new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(editable)
                , settings: RouteSettings(arguments: model)),
          );
        },
        child: new Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          child: new SizedBox(
            height: 280,
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
                    child:
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _BuildImageWidget())
                ),

                new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(model
                              .EnglishTitle, style: TextStyle(
                              fontSize: 15,
                              height: 1.2
                          ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,),
                          Text("${model.Price}+${allTranslations.text('cuurency')} ",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,

                            style: TextStyle(color: Theme
                                .of(context)
                                .accentColor),),
                          Divider(height: 1,
                            color: Colors.grey.shade300,
                            thickness: 1,),
                          Row(

                            children: <Widget>[
                              Icon(Icons.pin_drop_outlined, size: 20,),

                              Text(model
                                  .CityNameEnglish,),

                            ],),
                          Row(
                            children: <Widget>[
                              Icon(Icons.update_outlined, size: 20,),

                              FittedBox(
                                child: Text(
                                  displayTimeAgoFromTimestamp(model.CreationTime), style: TextStyle(fontSize: 13),),
                              ),

                            ],),


                        ],


                      ),
                    )

                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ InkWell(

                      onTap: () {},
                      child: Container(
                          margin: EdgeInsets.only(left: 4),

                          alignment: Alignment.topRight,
                          color: Colors.white,
                          child: FavroiteWidget(
                              onFavChange: (val) {
                                if (BlocProvider.of<LoginBloc>(context)
                                    .isLogged())
                                  BlocProvider.of<FavroiteBloc>(context)
                                      .changeFavoriteState(val, model.Id);
                                else
                                  Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) => ParentAuthPage()));
                              },
                              value: model.IsFavorite
                          )
                      ),
                    ),
                    ]
                ),

              ],
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
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}