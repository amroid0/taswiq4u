import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/favroite_entity.dart';
import 'package:olx/pages/detail_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/ads_widget_card.dart';
import 'package:olx/widget/ads_widget_row.dart';
import 'package:olx/widget/favroite_widget.dart';

class MyAdsPage extends StatefulWidget {
  @override
  _MyAdsPageState createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  int _sortSelectedValue=1;
  ScrollController _scrollController = new ScrollController();
  int page=1;
  List<AdsModel> ads;
  int lang ;
  String countryId;

  var _gridItemCount=1;
  var bloc;
 AdsBloc _bloc= AdsBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupId();
    bloc=new FavroiteBloc();

    bloc.stateStream.listen((data) {
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



    _bloc.getMyAdsListe(1);

    _scrollController.addListener(() {
      var isLoadMore;
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent&&isLoadMore==null) {
        //todo paging
        /*    if(ads.advertisementList.page==1)
          BlocProvider.of<AdsBloc>(context).submitQuery(params
              ,_sortSelectedValue,2);
          else if(ads.advertisementList.hasNextPage)
        BlocProvider.of<AdsBloc>(context).submitQuery(params,
            _sortSelectedValue,ads.advertisementList.nextPage);
*/



      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // BlocProvider.of<AdsBloc>(context).dispose();
    _scrollController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: <Widget>[


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



          Expanded(
            child: StreamBuilder<ApiResponse<List<AdsModel>>>(
              stream: _bloc.myAdsstream,
              builder:(context,snap){
                if(snap.data!=null)
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
                    ads=snap.data.data as List<AdsModel>;
                    return _buildAdsList(ads);
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


    );

  }
  Widget _buildAdsList(List<AdsModel> ads){
    if(ads.isEmpty)

      return EmptyListWidget(

          title: 'Empty Ads',
          subTitle: 'No  Ads available yet',
          image: 'images/ads_empty.png',
          titleTextStyle: Theme.of(context).typography.dense.display1.copyWith(color: Color(0xff9da9c7)),
          subtitleTextStyle: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6))
      );

    else
    if(_gridItemCount==2)
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _gridItemCount,
            childAspectRatio: 0.70,),
          controller: _scrollController,

          shrinkWrap: true,
          itemCount: ads.length,
          itemBuilder: (BuildContext context,int index){


            int adsIndex=index;

            if(ads[adsIndex]==null){
              return _buildLoaderListItem();

            }else {

              return AdsCardWidget(model:ads[adsIndex],editable: true,language: lang,);


            }
          }


      );
    else
      return ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: ads.length,
          itemBuilder: (BuildContext context,int index){

            int adsIndex=index;

            if(ads[adsIndex]==null){
              return _buildLoaderListItem();

            }else {
              List<AdvertismentImage> imageList = ads
              [adsIndex]
                  .AdvertismentImages;

              return AdsRowWidget(model:ads[adsIndex],editable: true,language:lang,);


            }
          }


      );


  }





  Widget _buildLoaderListItem() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  void getGroupId() async{
    countryId = await preferences.getCountryID() ;
    lang = int.parse(countryId);
    print("group  value"+lang.toString());

  }

}
