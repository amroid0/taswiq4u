import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:olx/generated/i18n.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/utils/global_locale.dart';

import 'Walkthrouth_page.dart';
import 'country_page.dart';
import 'language_page.dart';

class WelocmeScreen extends StatefulWidget {
  @override
  _WelocmeScreenState createState() => _WelocmeScreenState();
}

class _WelocmeScreenState extends State<WelocmeScreen> {
  int? currentIndexPage;
  late int pageLength;
  PageController _controller = PageController(initialPage: 0, keepPage: false);

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.bounceInOut;
  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 3;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            PageView(
              controller: _controller,
              children: <Widget>[
                SlideInUp(child: Walkthrougth(textContent: allTranslations.text('welcome1'), imagePath: 'images/online_shop.png',textDetail: allTranslations.text('welcome1_desc'),)),
                SlideInUp(child: Walkthrougth(textContent: allTranslations.text('welcome2'),imagePath: 'images/wallet.png',textDetail: allTranslations.text('welcome2_desc'),)),
                SlideInUp(child: Walkthrougth(textContent:  allTranslations.text('welcome3'),imagePath: 'images/discover.png',textDetail: allTranslations.text('welcome3_desc'),)),
              ],
              onPageChanged: (value) {
                setState(() => currentIndexPage = value);
              },
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[

                 FlatButton(child: new Text(allTranslations.text('next')!,style: TextStyle(fontWeight: FontWeight.bold)),onPressed:(){
                   setState(() {
                     if(currentIndexPage==2){
                       Navigator.push(context,MaterialPageRoute(builder: (context) => CountryPage()));
                     }else{
                      currentIndexPage=currentIndexPage!+1;
                     }
                     _controller.animateToPage(currentIndexPage!, duration: _kDuration, curve: _kCurve);
                   });
                 },),


                     DotsIndicator(
                    dotsCount:pageLength ,
             position: currentIndexPage!.toDouble(),
                  decorator: DotsDecorator(activeColor: Colors.green),),

                    FlatButton(child: new Text(allTranslations.text('skip')!,style: TextStyle(fontWeight: FontWeight.bold),),onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => CountryPage()));
                    },),




                  ]

                ),
              )

          ],
        ));
  }


}
