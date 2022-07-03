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
import 'package:olx/utils/ToastUtils.dart';
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
   bool isFirstLoad=true;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null&&isFirstLoad) {
      isFirstLoad=false;
      list = arguments["list"] as List< PopupAdsEntityList> ;
      currentPage=arguments["index"]as int;
    }
    _pageController=PageController(initialPage: currentPage,viewportFraction:1, keepPage: true,);

   // _pageController.jumpToPage(currentPage);
         return SafeArea(
           child: Scaffold(
               backgroundColor: Colors.black.withOpacity(.70),
               body:
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                   Container(
                     decoration: BoxDecoration(
                         color: Color(0xff202830),
                         borderRadius: BorderRadius.all(Radius.circular(12))
                     ),
                     //set this opacity as per your requirement
                     child: IconButton(
                       iconSize: 30,
                       icon: Icon(
                         Icons.close,
                         color: Colors.white,
                       ),
                       onPressed: () {
                         Navigator.pop(context);
                       },
                       tooltip: 'back',
                     ),
                   ),
                   SizedBox(height: 16),
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                     ),
                     width: MediaQuery.of(context).size.width,
                     height: MediaQuery.of(context).size.height * 0.55,
                     child: ClipRRect(
                       borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                       child: PhotoViewGallery.builder(
                         itemCount: list.length,
                         builder: (context, index) {
                           var item=list[index];
                           return PhotoViewGalleryPageOptions(

                             imageProvider: NetworkImage(
                                 APIConstants.getFullImageUrl(item.systemDataFile1!=null ?item.systemDataFile1.url:"", ImageType.COMMAD)
                             ),
                             // Contained = the smallest possible size to fit one dimension of the screen
                             minScale: PhotoViewComputedScale.covered ,
                             // Covered = the smallest possible size to fit the whole screen
                             maxScale: PhotoViewComputedScale.covered * 2,
                           );
                         },
                         scrollPhysics: BouncingScrollPhysics(),
                         // Set the background color to the "classic white"
                         backgroundDecoration: BoxDecoration(
                           color: Colors.white,
                         ),
                         pageController:_pageController,
                         onPageChanged: (i){
                           currentPage=i;
                           BlocProvider.of<OfferBloc>(context).refresh(list[currentPage].likes, list[currentPage].viewsCount);
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
                     ),
                   ),
                     Container(
                       decoration: BoxDecoration(
                           color: Colors.white,

                           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12) ,bottomRight: Radius.circular(12) )
                       ),
                       padding: EdgeInsets.all(16),
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         crossAxisAlignment: CrossAxisAlignment.start,

                         children: <Widget>[
                           Text(
                             list[currentPage].description==null?"":list[currentPage].description,
                             style: TextStyle(color: Color(0xff2D3142)),
                           ),
                           SizedBox(
                             height: 8,
                           ),
                           Row(
                             children: [
                               Row(children: <Widget>[
                                 _buildViewWidget(currentPage, list[currentPage]),
                                 SizedBox(
                                   width: 4,
                                 ),
                               ]),
                               SizedBox(
                                 width: 8,
                               ),
                               _buildLikeWidget(currentPage, list[currentPage]),
                             ],
                           ),
                           SizedBox(
                             height: 19,
                           ),
                           Row(
                             children: <Widget>[
                               InkWell(
                                   onTap: () async {
                                     var url = list[currentPage].phoneNumber;
                                     if (await canLaunch('tel:$url'))
                                       await launch('tel:$url');
                                     else
                                       // can't launch url, there is some error
                                       ToastUtils.showErrorMessage("رقم الهاتف غير صحيح");
                                   },
                                   child: Container(
                                       width: 38,
                                       height: 38,
                                       padding: EdgeInsets.all(4.0),
                                       decoration: BoxDecoration(
                                         color: Color(0xFFCAD1E0),
                                         borderRadius: BorderRadius.all(
                                           Radius.circular(12.0),
                                         ),
                                       ),
                                       child: Icon(
                                         MdiIcons.phoneInTalk,
                                         color: Color(0xff0AB3FF),
                                         size: 30,
                                       ))),
                               SizedBox(
                                 width: 12,
                               ),
                               InkWell(
                                   onTap: () async {
                                     var whatsappUrl ="whatsapp://send?phone=${list[currentPage].phoneNumber}";
                                     await canLaunch(whatsappUrl)? launch(whatsappUrl):ToastUtils.showErrorMessage("رقم الهاتف غير صحيح");

                                   },
                                   child: Container(
                                       width: 38,
                                       height: 38,
                                       padding: EdgeInsets.all(4.0),
                                       decoration: BoxDecoration(
                                         color: Color(0xFFCAD1E0),
                                         borderRadius: BorderRadius.all(
                                           Radius.circular(12.0),
                                         ),
                                       ),
                                       child: Icon(
                                         MdiIcons.whatsapp,
                                         color: AppColors.accentColor,
                                         size: 30,
                                       ))),
                               SizedBox(
                                 width: 12,
                               ),
                               InkWell(
                                   onTap: () async {
                                     const url = "http://taswiq4u.com/";
                                     if (await canLaunch(url))
                                       await launch(url);
                                     else
                                       // can't launch url, there is some error
                                       throw "Could not launch $url";
                                   },
                                   child: Container(
                                       width: 38,
                                       height: 38,
                                       padding: EdgeInsets.all(4.0),
                                       decoration: BoxDecoration(
                                         color: Color(0xFFCAD1E0),
                                         borderRadius: BorderRadius.all(
                                           Radius.circular(12.0),
                                         ),
                                       ),
                                       child: Icon(
                                         Icons.language_outlined,
                                         color: Color(0xff00E4F0),
                                         size: 30,
                                       ))),
                               SizedBox(
                                 width: 12,
                               ),
                               InkWell(
                                   onTap: () async {
                                     var url = list[currentPage].instagramLink;
                                     if (await canLaunch(url))
                                       await launch(url);
                                     else
                                       // can't launch url, there is some error
                                       ToastUtils.showErrorMessage("اللينك غير صالح");
                                   },
                                   child: Container(
                                       width: 38,
                                       height: 38,
                                       padding: EdgeInsets.all(4.0),
                                       decoration: BoxDecoration(
                                         color: Color(0xFFCAD1E0),
                                         borderRadius: BorderRadius.all(
                                           Radius.circular(12.0),
                                         ),
                                       ),
                                       child: Icon(
                                         MdiIcons.instagram,
                                         color: Color(0xff7623BE),
                                         size: 30,
                                       ))),
                             ],
                           )
                         ],
                       ),
                     ),

                  /*   Align(
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
                               var whatsappUrl ="whatsapp://send?phone=${list[currentPage].phoneNumber}";
                               await canLaunch(whatsappUrl)? launch(whatsappUrl):ToastUtils.showErrorMessage("رقم الهاتف غير صحيح");

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
                               SizedBox(width: 12,),
                               InkWell(
                                   onTap: ()async{
                                     var url = list[currentPage].instagramLink;
                                     if (await canLaunch(url))
                                       await launch(url);
                                     else
                                       // can't launch url, there is some error
                                       ToastUtils.showErrorMessage("اللينك غير صالح");
                                   },
                                   child: Icon(MdiIcons.instagram,color: Colors.white,size: 36,)),

                               SizedBox(width: 12,),
                               InkWell(
                                   onTap: ()async{
                                     var url = list[currentPage].phoneNumber;
                                     if (await canLaunch('tel:$url'))
                                       await launch('tel:$url');
                                     else
                                       // can't launch url, there is some error
                                       ToastUtils.showErrorMessage("رقم الهاتف غير صحيح");
                                     },
                                   child: Icon(MdiIcons.phone,color: Colors.white,size: 36,)),


                               _buildViewWidget(currentPage,list[currentPage])
                             ],)

                         ],
                       ),
                     ),
                   ),*/




               ]
               ),
             )
           ),
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

        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(onTap:(){
                BlocProvider.of<OfferBloc>(context).likeAds(pos,true);

              },child: Icon(Icons.remove_red_eye,color:AppColors.accentColor ),),
             SizedBox(width: 4,),
              Text(viewCounter.count.toString(),style: TextStyle(color: AppColors.accentColor,)),
            ]
        );
      },
    );


  }

  Widget _buildLikeWidget(int pos,PopupAdsEntityList item){

    return   StreamBuilder<Counter>(
      initialData:Counter(item.likes,item.isLiked) ,
      stream: BlocProvider.of<OfferBloc>(context).Likestream,
      builder: (context,snapshot){
        Counter likeCounter=Counter(0,false);
        if(snapshot.hasData)
          likeCounter=snapshot.data;
        return  Row(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(onTap:(){
                if(!likeCounter.isLiked)
                BlocProvider.of<OfferBloc>(context).likePopUpAds(item,true);

              },child: Icon(likeCounter.isLiked?Icons.favorite :Icons.favorite_border,color: AppColors.accentColor,)),
            SizedBox(width: 4,),
              Text(likeCounter.count.toString(),style: TextStyle(color: AppColors.accentColor),),

            ]
        );
      },
    );


  }

}
