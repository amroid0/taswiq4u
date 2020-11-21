import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/pages/detail_page.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/favroite_widget.dart';

class AdsCardWidget extends StatelessWidget {
  AdsModel model;
  AdsCardWidget(this.model);
  @override
  Widget build(BuildContext context) {
         return Container(

      margin: const EdgeInsets.all(4),
      child: new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(false)
                ,settings: RouteSettings(arguments: model)),
          );
        },
        child: new Card(
          elevation: 4,
          child: new SizedBox(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                new Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4)),

                    ),
                    child:
                   _BuildImageWidget()
                ),

                new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(model
                              .EnglishTitle),
                          Text("${model.Price} م.ج",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,

                            style: TextStyle(color: Theme
                                .of(context)
                                .accentColor),),
                          Divider(height: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: <Widget>[
                              Text(model
                                  .CityNameEnglish, style: TextStyle(color: Colors.grey)),
                              Icon(Icons.pin_drop, size: 16,color: Colors.grey,),

                            ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[

                              Flexible(
                                child: Text( DateFormatter.FormateDate(model
                                    .CreationTime.toIso8601String()), style: TextStyle(color: Colors.grey)),
                              ),
                              Icon(Icons.update, size: 16,color: Colors.grey,),

                            ],),


                        ],


                      ),
                    )


                ),
                InkWell(

                  onTap: () {},
                  child: Container(
                      margin: EdgeInsets.only(left: 4),

                      alignment: Alignment.center,
                      color: Colors.white,
                      child: FavroiteWidget(
                          onFavChange:(val){
                            BlocProvider.of<FavroiteBloc>(context).changeFavoriteState(val,model.Id);
                          },value: true
                      )
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );;
  }

  Widget _BuildImageWidget(){
    if(model.AdvertismentImages.isNotEmpty)
      return  CachedNetworkImage(
        fit: BoxFit.cover,
        placeholder: (context, url) => Image.asset("images/logo.png"),
        errorWidget: (context, url,error) => Image.asset("images/logo.png"),
        imageUrl: APIConstants.getFullImageUrl(model.AdvertismentImages[0].Url,ImageType.ADS),
      );
    else
    return  Image.asset("images/logo.png",fit: BoxFit.cover,);



  }

}
