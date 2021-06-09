import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/ShowListWidget.dart';
import 'package:olx/widget/ads_widget_card.dart';
import 'package:olx/widget/ads_widget_row.dart';
import 'package:olx/widget/favroite_widget.dart';

import 'detail_page.dart';
import 'full_commerical_ads_screen.dart';

class DummyDelegate extends SearchDelegate<String> {
  int _sortSelectedValue=1;
  AdsBloc _bloc=AdsBloc();
  int page=1;
  AdsEntity ads;
  ScrollController _scrollController = new ScrollController();

  var _gridItemCount=1;
  var favbloc;


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showResults(context);

          },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    _bloc.searchWithKey(query, _sortSelectedValue);
    favbloc=new FavroiteBloc();

    favbloc.stateStream.listen((data) {
      // Redirect to another view, given your condition

      switch (data.status) {
        case Status.LOADING:

          break;



        case Status.ERROR:

          break;
        case Status.COMPLETED:
        // TODO: Handle this case.
          var isLogged=data as ApiResponse<bool>;
          var isss=isLogged.data;
          if(isss) {
            Fluttertoast.showToast(
                msg: "Favorite",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }else{

            Fluttertoast.showToast(
                msg: "UnFavorite",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );



          }
          break;

      }
    });

    return BlocProvider<FavroiteBloc>(
      bloc: favbloc,
      child: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ShowListWidget(value: 1,onvalueChange: (val){
                    _gridItemCount=val;
                    //_buildAdsList(ads,context);
                  _bloc.refreshData();

                },)
               ,
                Text(allTranslations.text('sort')),
                InkWell(
                  onTap: (){
                    _newSortModalBottomSheet(context);

                  },
                  child: Container(

                    width: 36
                    ,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)
                        ,boxShadow:[ BoxShadow(color: Colors.black12,blurRadius: 10)],color: Colors.white),
                    child: Icon(Icons.sort_by_alpha), ),
                ),

              ],),



            Expanded(
              child: StreamBuilder<ApiResponse<AdsEntity>>(
                stream: _bloc.stream,
                builder:(context,snap){
                  switch(snap.data.status) {
                    case Status.LOADING:
                      if(page==1)
                        return new Center(
                          child: new CircularProgressIndicator(
                            backgroundColor: Colors.deepOrangeAccent,
                            strokeWidth: 5.0,
                          ),
                        );

                      break;

                    case Status.COMPLETED:
                      ads=snap.data.data as AdsEntity;
                      return _buildAdsList(ads,context);
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
              ),
            )
          ],
        ),
      ),
    );}

  @override
  Widget buildSuggestions(BuildContext context) {

    return Text('');
  }


  Widget _buildAdsList(AdsEntity ads, BuildContext context){
    if(ads.advertisementList.isEmpty)

      return EmptyListWidget(

          title: 'Empty Ads',
          subTitle: 'No  Ads available yet',
          image: 'images/ads_empty.png',
          titleTextStyle: Theme.of(context).typography.dense.display1.copyWith(color: Color(0xff9da9c7)),
          subtitleTextStyle: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6))
      );

    else
    if(_gridItemCount==2)
      return
        StaggeredGridView.countBuilder(
          controller: _scrollController,
          shrinkWrap: true,
          crossAxisCount:_gridItemCount , //as per your requirement
          itemCount: ads.advertisementList.length +(ads.advertisementList.length/6).toInt(),
          itemBuilder: (BuildContext context, int index) {
            if (index % 7 == 0) { //for even row
              int comIndex=(index/7-1).toInt();
              return GestureDetector(
                onTap: (){
                  if(ads.commercialAdsList.isNotEmpty&&comIndex<ads.commercialAdsList.length){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullComerialScreen()
                          ,settings: RouteSettings(arguments: ads.commercialAdsList[comIndex])),
                    );

                  }

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:Colors.black12,
                  ),
                  child: _BuildImageWidget(ads.commercialAdsList,comIndex)

                  ,
                ),
              );
            } else { //for odd row
              int adsIndex=index-(index/7).toInt();
              return AdsCardWidget(ads.advertisementList[adsIndex]);


            }
          },
          staggeredTileBuilder: (int index) => index % 7 == 0
              ? new StaggeredTile.fit(2)
              : new StaggeredTile.fit(1),
        );
    else
      return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: ads.advertisementList.length +(ads.advertisementList.length/6).toInt(),
        itemBuilder: (BuildContext context,int index){

          if(index!=0&& index%6==0){
            int comIndex=(index/6-1).toInt();
            String commercialAdsItem="";
            if(ads.commercialAdsList.isNotEmpty&&comIndex<ads.commercialAdsList.length){
              commercialAdsItem=ads.commercialAdsList[comIndex].Link;
/*
                if( ads.commercialAdsList[comIndex].base64Image==null&& ads.commercialAdsList[comIndex].isLoading==null)
                  BlocProvider.of<AdsBloc>(context).GetImage(commercialAdsItem,comIndex,true);*/
            }
            return GestureDetector(
              onTap: (){
                if(ads.commercialAdsList.isNotEmpty&&comIndex<ads.commercialAdsList.length){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullComerialScreen()
                        ,settings: RouteSettings(arguments: ads.commercialAdsList[comIndex])),
                  );

                }

              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:Colors.black12,
                  ),
                  child:  CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset("images/logo.png"),
                    errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                    imageUrl: APIConstants.getFullImageUrl(ads.commercialAdsList.isEmpty||comIndex>=ads.commercialAdsList.length?"":
                    ads.commercialAdsList[comIndex].systemDataFile.Url,ImageType.COMMAD),
                  )

              ),
            );

          }else {
            int adsIndex=index-(index/6).toInt();

            if(ads.advertisementList[adsIndex]==null){
              return _buildLoaderListItem();

            }else {
              return AdsRowWidget(ads.advertisementList[adsIndex]);


            }
          }

        },
      );


  }

  void _OnSelectSort(int val,BuildContext context){
    _sortSelectedValue=val;
    _bloc.searchWithKey(query,val);
    Navigator.of(context).pop();
  }
  void _newSortModalBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[


                Directionality(textDirection: TextDirection.rtl,

                  child: RadioListTile(
                    value: 1,
                    groupValue: _sortSelectedValue,
                    title: Text(allTranslations.text('hightest_price'),style: TextStyle(color: Colors.black),),
                    onChanged: (val) {
                      _OnSelectSort(val,context);
                    },

                    selected: true,
                  ),
                ),
                Divider(height: 2,color: Colors.grey,),
                Directionality(textDirection: TextDirection.rtl,

                  child: RadioListTile(
                    value: 2,
                    groupValue: _sortSelectedValue,
                    title: Text(allTranslations.text('lowest_price'),style: TextStyle(color: Colors.black)),
                    onChanged: (val) {
                      _OnSelectSort(val,context);

                    },

                    selected: true,

                  ),
                ),
                Divider(height: 2,color: Colors.grey,),
                Directionality(textDirection: TextDirection.rtl,
                  child: RadioListTile(
                    value: 3,
                    groupValue: _sortSelectedValue,
                    title: Text(allTranslations.text('recently_added'),style: TextStyle(color: Colors.black)),
                    onChanged: (val) {
                      _OnSelectSort(val,context);
                    },

                    selected: true,
                  ),
                ),

              ],
            ),
          );
        }
    );
  }

  Widget _buildLoaderListItem() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _BuildImageWidget(List<CommercialAdsList> list,int index){
    if(list.isNotEmpty&&list[0].systemDataFile.Url!=null&&list[0].systemDataFile.Url.isNotEmpty)
      return  CachedNetworkImage(
        fit: BoxFit.cover,
        placeholder: (context, url) => Image.asset("images/logo.png"),
        errorWidget: (context, url,error) => Image.asset("images/logo.png"),
        imageUrl: APIConstants.getFullImageUrl(list[0].systemDataFile.Url,ImageType.ADS),
      );
    else
      return  Image.asset("images/logo.png",fit: BoxFit.cover,);

  }
}