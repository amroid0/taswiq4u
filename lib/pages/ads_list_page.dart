
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/filter_response.dart';
import 'package:olx/pages/filter_page.dart';
import 'package:olx/pages/full_commerical_ads_screen.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/ads_widget_card.dart';
import 'package:olx/widget/ads_widget_row.dart';

import 'package:olx/widget/base64_image.dart';
import 'package:olx/widget/favroite_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'detail_page.dart';

class SearchAnnounceListScreen extends StatefulWidget {
  CateogryEntity category;
  SearchAnnounceListScreen(this.category);

  @override
  _SearchAnnounceListScreenState createState() => _SearchAnnounceListScreenState();
}

class _SearchAnnounceListScreenState extends State<SearchAnnounceListScreen> {
  int? _sortSelectedValue=2;
  ScrollController _scrollController = new ScrollController();
   int page=1;
  AdsEntity? ads;
  FilterParamsEntity params=new FilterParamsEntity();
  int? lang ;
  String? countryId;

  var _gridItemCount=1;

  FavroiteBloc? favbloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupId();
    params.categoryId=widget.category.id;
    params.cateName=allTranslations.isEnglish?widget.category.englishDescription:widget.category.arabicDescription;
    BlocProvider.of<AdsBloc>(context).submitQuery(params,_sortSelectedValue,1);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent&&ads!.isLoadMore==null) {
        page++;
        BlocProvider.of<AdsBloc>(context).submitQuery(params,_sortSelectedValue,page);


      }
    });
    favbloc=new FavroiteBloc();

    favbloc!.stateStream.listen((data) {
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
          favbloc!.getFavroite(1);
          break;

      }
    });




  }
  @override
  void dispose() {
    // TODO: implement dispose
    //BlocProvider.of<AdsBloc>(context).dispose();
    _scrollController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        title: Text(allTranslations.isEnglish?widget.category.englishDescription!:widget.category.arabicDescription!,style: TextStyles.appBarTitle,),
        centerTitle: true,
        actions: <Widget>[
          Icon(Icons.search,color: Colors.black,size: 30,),

        ],
        leading:  IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: 30,),
            onPressed: () => Navigator.pop(context)
        ),
        elevation: 0,

      ),//appbar
      body: BlocProvider<FavroiteBloc?>(
        bloc: favbloc,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(allTranslations.text('filter_by')!),
              InkWell(
                onTap: () async {
                 var retunObject= await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BlocProvider(bloc: AdsBloc(),child:FilterPage(),),
                  settings: RouteSettings(arguments:params)

                  ));

                  if(retunObject!=null) {
                    params=retunObject;
                    BlocProvider.of<AdsBloc>(context).submitQuery(
                        params, _sortSelectedValue, 1);
                  }
                },
                child: Container(

                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)
                        ,boxShadow:[ BoxShadow(color: Colors.black12,blurRadius: 10)],color: Colors.white),
                    child: Icon(Icons.filter),),
              ),

                Text(allTranslations.text('sort')!),
                InkWell(
                  onTap: (){
                    _newSortModalBottomSheet(context);

                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)
                        ,boxShadow:[ BoxShadow(color: Colors.black12,blurRadius: 10)],color: Colors.white),
                    child: Icon(Icons.sort_by_alpha), ),
                ),

                IconButton(
                  iconSize: 36,
                  icon:Icon(Icons.view_list),
                onPressed: (){
                  setState(() {
                    if(_gridItemCount==1){
                      _gridItemCount=2;
                    }else{
                      _gridItemCount=1;

                    }
                  });


                },
                )



          ],),

            _buildCategoryList(BlocProvider.of<CategoryBloc>(context).getCurrentCategory()),



            StreamBuilder<ApiResponse<AdsEntity>>(
              stream: BlocProvider.of<AdsBloc>(context).stream,
              builder:(context,snap){
                switch(snap.data?.status) {
                  case Status.LOADING:
                    if(page==1)
                    return  Expanded(
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 120.0,
                            height: 100.0,
                            color: Colors.white,

                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: 40.0,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                    ),


                itemCount: 15,
                        ),
                      )
                    );

                    break;

                  case Status.COMPLETED:
                     ads=snap.data!.data as AdsEntity?;
                    return _buildAdsList(ads!);
                    break;
                  case Status.ERROR:
                    return EmptyWidget(

                        title: 'Error',
                        subTitle: 'Something Went Wrong',
                        image: 'images/error.png',
                        titleTextStyle: Theme.of(context).typography.dense.displayMedium!.copyWith(color: Color(0xff9da9c7)),
                        subtitleTextStyle: Theme.of(context).typography.dense.bodySmall!.copyWith(color: Color(0xffabb8d6))
                    );
                    break;
                }
                return Container();



              },
            )

          ],
        ),
      ),


    );

  }
  Widget _buildAdsList(AdsEntity ads){
    if(ads.advertisementList!.isEmpty)

    return EmptyWidget(

        title: 'Empty Ads',
        subTitle: 'No  Ads available yet',
        image: 'images/ads_empty.png',
        titleTextStyle: Theme.of(context).typography.dense.displayMedium!.copyWith(color: Color(0xff9da9c7)),
        subtitleTextStyle: Theme.of(context).typography.dense.bodySmall!.copyWith(color: Color(0xffabb8d6))
    );

    else
      if(_gridItemCount==2)
    return
      Expanded(
        child: SlideInUp(
          child: StaggeredGridView.countBuilder(
            controller: _scrollController,
            shrinkWrap: true,

            crossAxisCount:_gridItemCount , //as per your requirement
            itemCount: ads.advertisementList!.length +(ads.advertisementList!.length/6).toInt(),
            itemBuilder: (BuildContext context, int index) {
              if (index!=0&&index % 6 == 0) { //for even row
                int comIndex=(index/6-1).toInt();
                return GestureDetector(
                  onTap: (){
                    if(ads.commercialAdsList!.isNotEmpty&&comIndex<ads.commercialAdsList!.length){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullComerialScreen()
                            ,settings: RouteSettings(arguments: ads.commercialAdsList![comIndex])),
                      );

                    }

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:Colors.black12,
                    ),
                    child: _BuildImageWidget(ads.commercialAdsList!,comIndex)

                    ,
                  ),
                );
              } else { //for odd row
                int adsIndex=index-(index/6).toInt();
                if(ads.advertisementList![adsIndex]==null){
                  return _buildLoaderListItem();

                }
                      return AdsCardWidget(model:ads.advertisementList![adsIndex],language:lang);
                  }



              },


            staggeredTileBuilder: (int index) => index!=0&&index % 6 == 0
                ? new StaggeredTile.fit(2)
                : new StaggeredTile.fit(1),
          ),
        ),
      );
else {
        return Expanded(
          child: SlideInUp(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: ads.advertisementList!.length +(ads.advertisementList!.length/6).toInt(),
              itemBuilder: (BuildContext context,int index){

                if(index!=0&& index%6==0){
                  int comIndex=(index/6-1).toInt();
                  String? commercialAdsItem="";
                  if(ads.commercialAdsList!.isNotEmpty&&comIndex<ads.commercialAdsList!.length){
                    commercialAdsItem=ads.commercialAdsList![comIndex].Link;
/*
                    if( ads.commercialAdsList[comIndex].base74Image==null&& ads.commercialAdsList[comIndex].isLoading==null)
                      BlocProvider.of<AdsBloc>(context).GetImage(commercialAdsItem,comIndex,true);*/
                  }
                  return GestureDetector(
                    onTap: (){
                      if(ads.commercialAdsList!.isNotEmpty&&comIndex<ads.commercialAdsList!.length){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullComerialScreen()
                              ,settings: RouteSettings(arguments: ads.commercialAdsList![comIndex])),
                        );

                      }

                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:Colors.black12,
                        borderRadius:  BorderRadius.circular(20),

                      ),
                     child:  CachedNetworkImage(
                       fit: BoxFit.fill,
                       placeholder: (context, url) => Image.asset("images/logo.png"),
                       errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                        imageUrl: APIConstants.getFullImageUrl(ads.commercialAdsList!.isEmpty||comIndex>=ads.commercialAdsList!.length?"":
                        ads.commercialAdsList![comIndex].systemDataFile!.Url,ImageType.COMMAD),
                      )

                    ),
                  );

                }else {
                  int adsIndex=index-(index/6).toInt();

                  if(ads.advertisementList![adsIndex]==null){
                    return _buildLoaderListItem();

                  }else {

                          return AdsRowWidget(model:ads.advertisementList![adsIndex],language:lang);



                  }
                }

              },
            ),
          ),
        );
      }


  }






void _OnSelectSort(int? val){
  _sortSelectedValue=val;
  page=1;
  BlocProvider.of<AdsBloc>(context).submitQuery(params,val,page);
  Navigator.of(context).pop();
}
  void _newSortModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[


                Directionality(textDirection: TextDirection.rtl,

                  child: RadioListTile(
                    value: 2,
                    groupValue: _sortSelectedValue,
                    title: Text(allTranslations.text('hightest_price')!,style: TextStyle(color: Colors.black),),
                    onChanged: (dynamic val) {
                      _OnSelectSort(val);
                    },

                    selected: true,
                  ),
                ),
                Divider(height: 2,color: Colors.grey,),
                Directionality(textDirection: TextDirection.rtl,

                  child: RadioListTile(
                    value: 1,
                    groupValue: _sortSelectedValue,
                    title: Text(allTranslations.text('lowest_price')!,style: TextStyle(color: Colors.black)),
                    onChanged: (dynamic val) {
                      _OnSelectSort(val);

                    },

                    selected: true,

                  ),
                ),
                Divider(height: 2,color: Colors.grey,),
                Directionality(textDirection: TextDirection.rtl,
                  child: RadioListTile(
                    value: 3,
                    groupValue: _sortSelectedValue,
                    title: Text(allTranslations.text('recently_added')!,style: TextStyle(color: Colors.black)),
                    onChanged: (dynamic val) {
                      _OnSelectSort(val);
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
    if(list.isNotEmpty&&list[0].systemDataFile!.Url!=null&&list[0].systemDataFile!.Url!.isNotEmpty)
      return  CachedNetworkImage(
        fit: BoxFit.fill,
        placeholder: (context, url) => Image.asset("images/logo.png"),
        errorWidget: (context, url,error) => Image.asset("images/logo.png"),
        imageUrl: APIConstants.getFullImageUrl(list[0].systemDataFile!.Url,ImageType.ADS),
      );
    else
      return  Image.asset("images/logo.png",fit: BoxFit.fill,);

  }

  Widget _buildCategoryList(List<CateogryEntity> category){
    return Visibility(
      visible: category[0].hasHorizontal!=null&&category[0].hasHorizontal!,
      child: Container(
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
                      label: Text(category[index].name!),
                      selected:category[index].isSelected==null?false:category[index].isSelected!||category[index].id==widget.category.id,
                      onSelected: (select){

                        category.forEach((item){
                          item.isSelected=false;
                        });
                        category[index].isSelected=true;
                        setState(() {

                          category.forEach((item){
                            item.isSelected=false;
                          });
                          category[index].isSelected=true;
                          widget.category=category[index];
                          params.categoryId=widget.category.id;
                          params.cateName=widget.category.name;
                          BlocProvider.of<AdsBloc>(context).submitQuery(params,_sortSelectedValue,1);

                        });


                      },

                    ),
                  )

              ),
            );


          },
        ),
      ),
    );


  }
void getGroupId() async{
  countryId = await preferences.getCountryID() ;
  lang = int.parse(countryId!);
  print("group  value"+lang.toString());

}



}
