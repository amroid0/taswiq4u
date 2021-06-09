import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/offfer_entity.dart';
import 'package:olx/pages/offer_detail_slider_page.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';


class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  CategoryBloc  _bloc;
  List<CateogryEntity>totalCateogryList;
  OfferBloc offerBloc;




  var chipselected=[];

  bool first=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    offerBloc=OfferBloc();
    offerBloc.getOfferCategory("");


  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: Container(
        padding: EdgeInsets.symmetric(vertical:0,horizontal:8),
        child: StreamBuilder<List<CateogryEntity>>(
           stream: offerBloc.categoryStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            List<CateogryEntity>categories=snapshot.data;
            if(first&&categories.isNotEmpty){
              first=false;
              categories[0].isSelected=true;
              offerBloc.getOfferLsit(categories[0].id.toString());

            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildCategoryList(categories),
               //Text('hello')
               Expanded(child: _buildOfferList())
              ],
            );
          }
        ),
      ),





/*
        BlocProvider(
            bloc: UploadImageBloc(),child:ImageInput()),*/

    );
  }

  Widget _buildOfferList(){

     return  StreamBuilder<ApiResponse<List<PopupAdsEntityList>>>(
          stream: offerBloc.stream,
          builder:(context,snap){
            if(snap.hasData)
            switch(snap.data.status) {

              case Status.LOADING:
                  return Padding(
                    padding:EdgeInsets.all(10),
                    child: new Center(
                      child: new CircularProgressIndicator(
                        backgroundColor: Colors.deepOrangeAccent,
                        strokeWidth: 5.0,
                      ),
                    ),
                  );

                break;

              case Status.COMPLETED:
                var offerObj=snap.data.data ;
                 if(offerObj.length!=0)
                return   GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  primary: true,
                  crossAxisCount: 2,
                  childAspectRatio: .9,
                  children: List.generate(offerObj.length, (index) {
                    return _getOfferGridCell(offerObj,index);
                  }),
                );
                 else
                   return EmptyListWidget(

                       title: 'Empty Offers',
                       subTitle: 'No  Offers available yet',
                       image: 'images/offer_empty.png',
                       titleTextStyle: Theme.of(context).typography.dense.display1.copyWith(color: Color(0xff9da9c7)),
                       subtitleTextStyle: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6))
                   );
                break;
              case Status.ERROR:
                return EmptyListWidget(

                    title: 'Error',
                    subTitle: 'Something Went Wrong',
                    image: 'images/error.png',
                    titleTextStyle: Theme.of(context).typography.dense.display1.copyWith(color: Color(0xff9da9c7)),
                    subtitleTextStyle: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6))
                );
                break;
            }
            return Container();



          },
        )
        ;


  }

  Widget _buildCategoryList(List<CateogryEntity> category){
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: category.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: new SizedBox(
              height: 60.0,
              child:     Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: ChoiceChip(
              label: Text(allTranslations.isEnglish?category[index].englishDescription:category[index].arabicDescription),
              selected:category[index].isSelected!=null&&category[index].isSelected,
              onSelected: (select){

                category.forEach((item){
                  item.isSelected=false;
                });
                category[index].isSelected=true;
                setState(() {

                  offerBloc.getOfferLsit(category[index].id.toString());
                });


              },

            ),
          )

          ),
          );


        },
      ),
    );


  }

  Widget _getOfferGridCell(List< PopupAdsEntityList> entity,int index) {
    var Item=entity[index];



    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(bloc: offerBloc,child: OfferSliderPage())
              ,settings: RouteSettings(arguments:{"list":entity,"index":index})));

      },
      child: new Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                height: 100.0,
                width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300
                  ),

                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child:
                    CachedNetworkImage(
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Image.asset("images/logo.png"),
                        errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                        imageUrl: APIConstants.getFullImageUrl(Item.systemDataFile.url, ImageType.COMMAD)
                    ),
                  )
              ),
              SizedBox(height: 4,),
              new Padding(
                padding: EdgeInsets.all(4.0),
                child: Container(
                  alignment: Alignment.center,
                    child: Text(Item.description!=null?Item.description:"",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16,height: 1.2),maxLines: 2,overflow: TextOverflow.ellipsis,),
                )

              )
            ],
          )),
    );
  }







}










