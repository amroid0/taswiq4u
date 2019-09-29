import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:olx/pages/parentAuthPage.dart';

import 'Walkthrouth_page.dart';
import 'language_page.dart';

class WelocmeScreen extends StatefulWidget {
  @override
  _WelocmeScreenState createState() => _WelocmeScreenState();
}

class _WelocmeScreenState extends State<WelocmeScreen> {
  int currentIndexPage;
  int pageLength;
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
                Walkthrougth(textContent: "Walkthrough one",
                  imagePath: 'images/online_shop.png',textDetail: "hellowsdjlkdsklsdajkjsdajsad",),
                Walkthrougth(textContent: "Walkthrough one",imagePath: 'images/wallet.png',textDetail: "hellowsdjlkdsklsdajkjsdajsad",),
                Walkthrougth(textContent: "Walkthrough one",imagePath: 'images/wallet.png',textDetail: "hellowsdjlkdsklsdajkjsdajsad",),
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

                 FlatButton(child: new Text('التالي',style: TextStyle(fontWeight: FontWeight.bold)),onPressed:(){
                   setState(() {
                     if(currentIndexPage==2){
                       currentIndexPage=0;
                     }else{
                       currentIndexPage++;
                     }
                     _controller.animateToPage(currentIndexPage, duration: _kDuration, curve: _kCurve);
                   });
                 },),


                     DotsIndicator(
                    dotsCount:pageLength ,
             position: currentIndexPage,
                  decorator: DotsDecorator(activeColor: Colors.green),),



                    FlatButton(child: new Text('تخطي',style: TextStyle(fontWeight: FontWeight.bold),),onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ChooseLanguagePage()));
                    },),




                  ]

                ),
              )

          ],
        ));
  }


}
