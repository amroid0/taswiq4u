import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/ShowListWidget.dart';
import 'package:olx/widget/ads_widget_card.dart';
import 'package:olx/widget/ads_widget_row.dart';
import 'package:olx/widget/favroite_widget.dart';

import 'detail_page.dart';
import 'full_commerical_ads_screen.dart';
import 'package:olx/widget/word_suggestion_list.dart';
import 'package:english_words/english_words.dart' as words;

class DummyDelegate extends SearchDelegate<String> {
  int _sortSelectedValue=1;
  AdsBloc _bloc=AdsBloc();
  int page=1;
  AdsEntity ads;
  ScrollController _scrollController = new ScrollController();
  String countryId ;
  int lang ;
   List<String> _words;
   List<String> _history;
  var _gridItemCount=1;
  var favbloc;
  DummyDelegate(List<String> history){
    _history =history;
   _words = List.from(Set.from(words.all))
    ..sort(
    (w1, w2) => w1.toLowerCase().compareTo(w2.toLowerCase()),
    );
   _words.addAll(_history);
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty
        ? _history
        : _words.where((word) => word.startsWith(query));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: this.query.isEmpty,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16,24,16,0),
            child: Text(allTranslations.text('recent_search'),style: TextStyle(color : Color(0x993c3c43)),),
          ),
        ),
       SizedBox(height: 8,),
        Divider(color: Color(0xffE3E7EF),),
        Expanded(
          child: WordSuggestionList(
            query: this.query,
            suggestions: suggestions.toList(),
            onSelected: (String suggestion) {
              this.query = suggestion;
              //this._history.insert(0, suggestion);
              showResults(context);
            },
          ),
        ),
      ],
    );
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      /*IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showResults(context);

          },
      ),*/
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Color(0xff2D3142),
        size: 30,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {

    if(!_history.contains(query))
    _history.insert(0, query);

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
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16),
                child: Row(
                  children: <Widget>[


                    InkWell(
                      onTap: () {
                        _newSortModalBottomSheet(context);
                      },
                      child: Icon(
                        FontAwesomeIcons.sortAmountDown,
                        size: 24,
                        color: Color(0xff2D3142),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    InkWell(
                        onTap: () {
                          _newSortModalBottomSheet(context);
                        },
                        child: Text(allTranslations.text('sort'))),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: VerticalDivider(
                          color: Color(0xffF5F5F5),
                          thickness: 1,
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Text('12'),
                    Text(allTranslations.text('result_count')),
                  ShowListWidget(value: _gridItemCount,onvalueChange: (val){
                    _gridItemCount=val;
                    //_buildAdsList(ads,context);
                    _bloc.refreshData();

                  },)
                  ],),
              ),
            ),



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
              return AdsCardWidget(model:ads.advertisementList[adsIndex]);


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
              return AdsRowWidget(model:ads.advertisementList[adsIndex]);


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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:16.0,horizontal: 16),
                  child: Text(allTranslations.text('sort_by'),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),

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
  void getGroupId() async{
    countryId = await preferences.getCountryID() ;
    lang = int.parse(countryId);
    print("group  value"+lang.toString());

  }
}