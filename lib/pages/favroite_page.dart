 import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/pages/detail_page.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/utils.dart';
import 'package:olx/widget/ads_widget_card.dart';
import 'package:olx/widget/ads_widget_row.dart';
import 'package:olx/widget/favroite_widget.dart';
 import 'package:olx/model/favroite_entity.dart';

class FavroitePage extends StatefulWidget {
   @override
   _FavroitePageState createState() => _FavroitePageState();
 }

 class _FavroitePageState extends State<FavroitePage> {
   int _sortSelectedValue=1;
   ScrollController _scrollController = new ScrollController();
   int page=1;
   FavoriteModel ads;

   var _gridItemCount=1;
   var bloc;
   int lang;
   String countryId;

   @override
   void initState() {
     // TODO: implement initState
     getGroupId();
     super.initState();
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
           bloc.getFavroite(1);
           break;

       }
     });



     bloc.getFavroite(1);

     _scrollController.addListener(() {
       if (_scrollController.position.pixels ==
           _scrollController.position.maxScrollExtent&&ads.isLoadMore==null) {
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
       body: BlocProvider<FavroiteBloc>(
         bloc: bloc,
         child: Column(
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
               child: StreamBuilder<ApiResponse<FavoriteModel>>(
                 stream: bloc.stream,
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
                       ads=snap.data.data as FavoriteModel;
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
       ),


     );

   }
   Widget _buildAdsList(FavoriteModel ads){
     if(ads.list.isEmpty)

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
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _gridItemCount,          childAspectRatio: 0.80,),
         controller: _scrollController,
         shrinkWrap: true,
         itemCount: ads.list.length,
         itemBuilder: (BuildContext context,int index){


             int adsIndex=index;

             if(ads.list[adsIndex]==null){
               return _buildLoaderListItem();

             }else {
               List<AdvertismentImage> imageList = ads.list[adsIndex]
                   .AdvertismentImages;
               /*if (imageList.isNotEmpty && imageList[0].base64Image == null &&
                 imageList[0].isLoading == null)
               BlocProvider.of<AdsBloc>(context).GetImage(
                   imageList[0].Url, adsIndex, false);*/

               return AdsCardWidget(model:ads.list[adsIndex],language: lang,);


             }
           }


       );
     else
       return ListView.builder(
         controller: _scrollController,
         shrinkWrap: true,
         itemCount: ads.list.length,
         itemBuilder: (BuildContext context,int index){

             int adsIndex=index;

             if(ads.list[adsIndex]==null){
               return _buildLoaderListItem();

             }else {
               List<AdvertismentImage> imageList = ads.list
               [adsIndex]
                   .AdvertismentImages;
               /*     if (imageList.isNotEmpty && imageList[0].base64Image == null &&
                    imageList[0].isLoading == null)
                  BlocProvider.of<AdsBloc>(context).GetImage(
                      imageList[0].Url, adsIndex, false);*/

               return AdsRowWidget(model: ads.list[adsIndex],language:lang,);



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
