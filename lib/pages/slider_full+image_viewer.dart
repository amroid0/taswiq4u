import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/detail_bloc.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/widget/base64_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class SliderFullImageViewer extends StatefulWidget {
  @override
  _SliderFullImageViewerState createState() => _SliderFullImageViewerState();
}

class _SliderFullImageViewerState extends State<SliderFullImageViewer> {
  PageController? _pageController;
  List<AdvertismentImage>?list;
  int? currentPage=0;
  int page=0 ;

  @override
  Widget build(BuildContext context) {
    final Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    if (arguments != null) {
      list = arguments["list"] as List<AdvertismentImage>?;
      currentPage=arguments["index"]as int?;
    }
      _pageController=PageController(initialPage: currentPage!,viewportFraction: 1, keepPage:true);
    // _pageController.jumpToPage(currentPage);
    return Scaffold(

      body: Stack(
        children: [
      PhotoViewGallery.builder(
      itemCount: list!.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              APIConstants.getFullImageUrl(list!.isEmpty?"":list![index].Url,ImageType.ADS),
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
        onPageChanged:(int x){
        setState(() {
          x++;
          page =x;
          print(page.toString());
        });

      } ,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
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
                  radius: 20,
                  child: Center(child: Icon(Icons.close,color: Colors.white,size: 36,)),

                ),
              ),
            ),
          ),
         Align(
           alignment:Alignment.bottomCenter,
           child:Container(margin:const EdgeInsets.only(bottom:24),child: Text('${page!=0?page:currentPage!+1}/${list!.length}',style:TextStyle(color:Colors.yellowAccent,fontSize:24),)),
         )

        ]

      ),
    );
  }
}
