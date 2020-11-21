import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/detail_bloc.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/widget/base64_image.dart';

class SliderFullImageViewer extends StatefulWidget {
  @override
  _SliderFullImageViewerState createState() => _SliderFullImageViewerState();
}

class _SliderFullImageViewerState extends State<SliderFullImageViewer> {
  PageController _pageController;
  List<AdvertismentImage>list;
  int currentPage=0;

  @override
  Widget build(BuildContext context) {

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      list = arguments["list"] as List<AdvertismentImage>;
      currentPage=arguments["index"]as int;
    }
    _pageController=PageController(initialPage: currentPage,viewportFraction: 1, keepPage: true);
    // _pageController.jumpToPage(currentPage);
    return Scaffold(
      body: Stack(
        children: [

          StreamBuilder(
            initialData: list,
            stream:BlocProvider.of<DetailBloc>(context).sliderStream,
              builder: (BuildContext context, snapshot) {
                List<AdvertismentImage>imageList=snapshot.data;


                return PageView.builder(
              controller: _pageController,
              itemBuilder: (context,pos){
                return Stack(
                  children: <Widget>[
              Container(

                width: double.infinity,
                height: double.infinity,
                child: CachedNetworkImage(
                    fit: BoxFit.cover,

                    placeholder: (context, url) => Image.asset("images/logo.png"),
                    errorWidget: (context, url,error) => Image.asset("images/logo.png"),
                    imageUrl: APIConstants.getFullImageUrl(imageList.isEmpty?"":imageList[pos].Url,ImageType.ADS),
                  ),
              ),
                Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                onPressed: (){
                _pageController.nextPage(duration: kTabScrollDuration, curve: Curves.ease);

                },
                padding: EdgeInsets.all(0.0),
                child:Icon(Icons.arrow_forward_ios,color: Colors.white,size: 40,))
                ),
                Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                onPressed: (){
                _pageController.previousPage(duration: kTabScrollDuration, curve: Curves.ease);

                },
                padding: EdgeInsets.all(0.0),
                child:Icon(Icons.arrow_back_ios,size:40,color: Colors.white,))

)]
                );
              },
              itemCount: imageList.length,
            );

    }
          ),

          Align(

            alignment:Alignment.topLeft ,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                onPressed: () {
                  Navigator.pop(context);

                },
                tooltip: 'back',
              ),
            ),
          ),

        ]

      ),
    );
  }
}
