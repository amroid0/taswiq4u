import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/pages/detail_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
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
                      padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(model
                              .EnglishTitle,style: TextStyle(
                            fontSize: 15,
                            height: 1.2
                          ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,),
                          Text("${model.Price} م.ج",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,

                            style: TextStyle(color: Theme
                                .of(context)
                                .accentColor),),
                          Divider(height: 1,color: Colors.grey.shade300,thickness: 1,),
                          Row(

                            children: <Widget>[
                              Icon(Icons.pin_drop_outlined, size: 20,),

                              Text(model
                                  .CityNameEnglish,),

                            ],),
                          Row(
                            children: <Widget>[
                              Icon(Icons.update_outlined,size: 20,),

                              FittedBox(
                                child: Text( DateFormatter.FormateDate(model
                                    .CreationTime.toIso8601String()),style: TextStyle(fontSize: 13), ),
                              ),

                            ],),


                        ],


                      ),
                    )


                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[ InkWell(

                    onTap: () {},
                    child: Container(
                        margin: EdgeInsets.only(left: 4),

                        alignment: Alignment.center,
                        color: Colors.white,
                        child: FavroiteWidget(
                            onFavChange:(val){
                              if(BlocProvider.of<LoginBloc>(context).isLogged())
                                BlocProvider.of<FavroiteBloc>(context).changeFavoriteState(val,model.Id);
                              else
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => ParentAuthPage()));
                            },
                            value: model.IsFavorite
                        )
                    ),
                  ),]
                ),

              ],
            ),
          ),
        ),
      ),
    );;
  }

  Widget _BuildImageWidget(){
    if(model.AdvertismentImages.isNotEmpty&&model.AdvertismentImages[0].Url!=null&&model.AdvertismentImages[0].Url.isNotEmpty)
      return  CachedNetworkImage(
        fit: BoxFit.fill,
        placeholder: (context, url) => Image.asset("images/logo.png"),
        errorWidget: (context, url,error) => Image.asset("images/logo.png"),
        imageUrl: APIConstants.getFullImageUrl(model.AdvertismentImages[0].Url,ImageType.ADS),
      );
    else
    return  Image.asset("images/logo.png",fit: BoxFit.fill,);



  }

}
