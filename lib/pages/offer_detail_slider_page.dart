import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/offer_bloc.dart';
import 'package:olx/model/Counter.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/offfer_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/widget/base64_image.dart';
import 'package:olx/model/popup_ads_entity_entity.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferSliderPage extends StatefulWidget {
  @override
  _OfferSliderPageState createState() => _OfferSliderPageState();
}


class _OfferSliderPageState extends State<OfferSliderPage> {
  PageController _pageController;
  List< PopupAdsEntityList>  list ;
   int currentPage=0;
   int ImageIndex=0 ;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      list = arguments["list"] as List< PopupAdsEntityList> ;
      currentPage=arguments["index"]as int;
    }
    _pageController=PageController(initialPage: currentPage,viewportFraction:1, keepPage: true,);

   // _pageController.jumpToPage(currentPage);
         return Scaffold(
           body:
           Stack(
             children: [

               PhotoViewGallery.builder(
                 itemCount: list.length,
                 builder: (context, index) {
                   var item=list[index];
                   return PhotoViewGalleryPageOptions(
                     imageProvider: NetworkImage(
                         APIConstants.getFullImageUrl(item.systemDataFile!=null ?item.systemDataFile.url:"", ImageType.COMMAD)
                     ),
                     // Contained = the smallest possible size to fit one dimension of the screen
                     minScale: PhotoViewComputedScale.contained * 0.8,
                     // Covered = the smallest possible size to fit the whole screen
                     maxScale: PhotoViewComputedScale.covered * 2,
                   );
                 },
                 scrollPhysics: BouncingScrollPhysics(),
                 // Set the background color to the "classic white"
                 backgroundDecoration: BoxDecoration(
                   color: Colors.black,
                 ),
                 pageController:_pageController,
                 onPageChanged: (i){
                   currentPage=i;
                   setState(() {
                   });
                 },
                 loadingBuilder: (context, event) => Center(
                   child: Container(
                     width: 20.0,
                     height: 20.0,
                     child: CircularProgressIndicator(
                       value: event == null
                           ? 0
                           : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                     ),
                   ),
                 ),
               ),



               Align(

                 alignment:AlignmentDirectional.topStart ,
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 30,horizontal: 16),
                   child: InkWell(
                     onTap: () {
                       Navigator.pop(context);

                     },
                     child: CircleAvatar(
                       backgroundColor: Colors.black,
                       radius: 18,
                       child: Center(child: Icon(Icons.close,color: Colors.white,size: 30,)),

                     ),
                   ),
                 ),
               ),


               Align(
                 alignment: Alignment.bottomLeft,

                 child: Container(

                   color: Color(0xFF0E3311).withOpacity(0.7),
                   child: Column(
                     mainAxisSize: MainAxisSize.min
                     ,
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: <Widget>[

                       SizedBox(height: 4,),
                       Text(list[currentPage].description==null?"":list[currentPage].description,style: TextStyle(color: Colors.white),),
                       SizedBox(height: 16,),

                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           _buildLikeWidget(currentPage,list[currentPage]),

                           InkWell(
                               onTap: ()async{
                           var whatsappUrl ="whatsapp://send?phone=${201119726142}";
                           await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");

                           },

                               child: Icon(MdiIcons.whatsapp,color: Colors.white,size: 36,)),
                           SizedBox(width: 12,),
                           InkWell(
                               onTap: ()async{
                                 const url = "http://taswiq4u.com/";
                                 if (await canLaunch(url))
                                   await launch(url);
                                 else
                                   // can't launch url, there is some error
                                   throw "Could not launch $url";
                               },
                               child: Icon(Icons.language_outlined,color: Colors.white,size: 36,)),

                           _buildViewWidget(currentPage,list[currentPage])
                         ],)

                     ],
                   ),
                 ),
               ),




           ]
           )
         );
  }

 Widget _buildViewWidget(int pos,PopupAdsEntityList item){

 return   StreamBuilder<Counter>(
   initialData:Counter(item.viewsCount,true) ,
      stream: BlocProvider.of<OfferBloc>(context).viewstream,
      builder: (context,snapshot){
        Counter viewCounter=Counter(0,true);
        if(snapshot.hasData)
          viewCounter=snapshot.data;

        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(viewCounter.count.toString(),style: TextStyle(color: Colors.white),),
              FlatButton(onPressed:(){
                BlocProvider.of<OfferBloc>(context).likeAds(pos,true);

              },child: Icon(Icons.remove_red_eye,color: Colors.white),),
            ]
        );
      },
    );


  }

  Widget _buildLikeWidget(int pos,PopupAdsEntityList item){

    return   StreamBuilder<Counter>(
      initialData:Counter(item.likes,true) ,
      stream: BlocProvider.of<OfferBloc>(context).Likestream,
      builder: (context,snapshot){
        Counter likeCounter=Counter(0,true);
        if(snapshot.hasData)
          likeCounter=snapshot.data;
        return  Column(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(likeCounter.count.toString(),style: TextStyle(color: Colors.white),),
              FlatButton(onPressed:(){
                BlocProvider.of<OfferBloc>(context).likeAds(pos,true);

              },child: Icon(likeCounter.isEanbled?Icons.favorite_border:Icons.favorite,color: Colors.white,)),
            ]
        );
      },
    );


  }

}
