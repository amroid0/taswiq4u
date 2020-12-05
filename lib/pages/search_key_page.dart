import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/pages/detail_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/favroite_widget.dart';

class SearchKeyScreen extends StatefulWidget {
  @override
  _SearchKeyScreenState createState() => _SearchKeyScreenState();
}

class _SearchKeyScreenState extends State<SearchKeyScreen> {
  int _sortSelectedValue=1;
  String searchQuery="";

  Widget appBarTitle =  Text(allTranslations.text('search'),style:TextStyles.appBarTitle ,);
  Icon actionIcon = new Icon(Icons.search);

  TextEditingController searchController;

  FavroiteBloc favbloc;
  @override
  void initState() {
    // TODO: implement initState
    searchController=TextEditingController();
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


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    searchQuery = ModalRoute.of(context).settings.arguments;
/*
    appBarTitle=Text(searchQuery,style:TextStyles.appBarTitle ,);
*/
    BlocProvider.of<AdsBloc>(context).searchWithKey(searchQuery,_sortSelectedValue);
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        title: appBarTitle,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward,color: Colors.black,),
              onPressed: () => {
            Navigator.pop(context)
              }),
        ],

        leading: IconButton(icon: actionIcon,color: Colors.black,onPressed:(){
          setState(() {
            if ( this.actionIcon.icon == Icons.search){
              this.actionIcon = new Icon(Icons.close);
              this.appBarTitle = new TextField(
                controller: searchController,
                style:TextStyles.appBarTitle,
                decoration: new InputDecoration(
                  prefixIcon: IconButton(icon:  Icon(Icons.search,color: Colors.grey),onPressed:()
                  {
                    if(searchController.text.toString().isNotEmpty)
                      searchQuery=searchController.text.toString();
                      BlocProvider.of<AdsBloc>(context).searchWithKey(searchQuery,_sortSelectedValue);

                  }
                    ,),

                  hintText: searchQuery.isEmpty?allTranslations.text('search'):searchQuery,
                  hintStyle: new TextStyle(color: Colors.green),


                ),
              );}
            else {
              this.actionIcon = new Icon(Icons.search,color: Colors.black,);
              this.appBarTitle = new Text(allTranslations.text('home'),style:TextStyles.appBarTitle,
              );

            }


          });
        } ,),
        elevation: 4,


      ),//appbar
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(allTranslations.text('filter_by')),
              InkWell(
                onTap: (){},
                child: Container(

                  width: 36
                  ,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)
                      ,boxShadow:[ BoxShadow(color: Colors.black12,blurRadius: 10)],color: Colors.white),
                  child: Icon(Icons.filter), ),
              ),

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
              stream: BlocProvider.of<AdsBloc>(context).stream,
              builder:(context,snap){
                switch(snap.data.status) {
                  case Status.LOADING:
                    return new Center(
                      child: new CircularProgressIndicator(
                        backgroundColor: Colors.deepOrangeAccent,
                        strokeWidth: 5.0,
                      ),
                    );
                    break;

                  case Status.COMPLETED:
                    AdsEntity ads=snap.data.data as AdsEntity;
                    return _buildAdsList(ads);
                    break;
                  case Status.ERROR:
                    return Center(child: Text(allTranslations.text('err_wrong')));
                    break;
                }
                return Container();



              },
            ),
          )

        ],
      ),


    );

  }
  Widget _buildAdsList(AdsEntity ads){
    return ListView.builder(
      itemCount: ads.advertisementList.length+ads.commercialAdsList.length,
      itemBuilder: (BuildContext context,int index){
        if(index!=0&& index%6==0){
          int comIndex=(index/6-1).toInt();
          String commercialAdsItem="http://www.image.com";
          if(ads.commercialAdsList.isNotEmpty&&comIndex<ads.commercialAdsList.length){
            commercialAdsItem=ads.commercialAdsList[comIndex].Link;
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
            decoration: BoxDecoration(
              color:Colors.black12,
            ),
            child: Image.network(
              commercialAdsItem,
              fit: BoxFit.fill,

            ),
          );

        }else {
          return Container(

            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(false)),
                );
              },
              child: new Card(
                elevation: 4,
                child: new SizedBox(
                  height: 120.0,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      InkWell(

                        onTap: () {},
                        child: Container(
                            margin: EdgeInsets.only(left: 4),

                            alignment: Alignment.center,
                            color: Colors.white,
                            child:FavroiteWidget(onFavChange:(val){

                              if(BlocProvider.of<LoginBloc>(context).isLogged())
                                favbloc.changeFavoriteState(val,ads.advertisementList[index].Id);
                              else
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => ParentAuthPage()));
                            },value: true,)
                        ),
                      ),


                      new Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(ads.advertisementList[index]
                                    .EnglishTitle),
                                Text(ads.advertisementList[index]
                                    .ArabicDescription,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,

                                  style: TextStyle(color: Theme
                                      .of(context)
                                      .accentColor),),
                                Divider(height: 1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,

                                  children: <Widget>[
                                    Text(ads.advertisementList[index]
                                        .CityNameEnglish),
                                    Icon(Icons.pin_drop, size: 16),

                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[

                                    Flexible(
                                      child: Text(ads.advertisementList[index]
                                          .CreationTime.toIso8601String()),
                                    ),
                                    Icon(Icons.update, size: 16,),

                                  ],),


                              ],


                            ),
                          )


                      ),
                      new Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4)),
                          color: Theme
                              .of(context)
                              .accentColor,

                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.directions_car, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

      },
    );


  }
  void _OnSelectSort(int val){
    _sortSelectedValue=val;
    BlocProvider.of<AdsBloc>(context).searchWithKey(searchQuery,val);
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
                    value: 1,
                    groupValue: _sortSelectedValue,
                    title: Text(allTranslations.text('hightest_price'),style: TextStyle(color: Colors.black),),
                    onChanged: (val) {
                      _OnSelectSort(val);
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
                    title: Text(allTranslations.text('recently_added'),style: TextStyle(color: Colors.black)),
                    onChanged: (val) {
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
}
