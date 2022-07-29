import 'package:animate_do/animate_do.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:olx/pages/main_page.dart';
import 'package:olx/utils/global_locale.dart';

import 'Walkthrouth_page.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainScreen()));
              },
              child: Text(
                "${allTranslations.text('skip')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              //_appBar(),
              PageView(
                controller: _controller,
                children: <Widget>[
                  SlideInUp(
                      child: Walkthrougth(
                    textContent: allTranslations.text('welcome1'),
                    imagePath: 'images/welcome_1.png',
                    textDetail: allTranslations.text('welcome1_desc'),
                    dot: DotsIndicator(
                      dotsCount: pageLength,
                      position: currentIndexPage,
                      decorator: DotsDecorator(
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeColor: Color(0xff53B553),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                  )),
                  SlideInUp(
                      child: Walkthrougth(
                    textContent: allTranslations.text('welcome2'),
                    imagePath: 'images/welcome_2.png',
                    textDetail: allTranslations.text('welcome2_desc'),
                    dot: DotsIndicator(
                      dotsCount: pageLength,
                      position: currentIndexPage,
                      decorator: DotsDecorator(
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeColor: Color(0xff53B553),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                  )),
                  SlideInUp(
                      child: Walkthrougth(
                    textContent: allTranslations.text('welcome3'),
                    imagePath: 'images/welcome_3.png',
                    textDetail: allTranslations.text('welcome3_desc'),
                    dot: DotsIndicator(
                      dotsCount: pageLength,
                      position: currentIndexPage,
                      decorator: DotsDecorator(
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeColor: Color(0xff53B553),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                  )),
                ],
                onPageChanged: (value) {
                  setState(() => currentIndexPage = value);
                },
              ),
              // SizedBox(
              //   height: 30,
              // ),
              //   _indicator()
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _indicator(),
                  // child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       FlatButton(
                  //         child: new Text(allTranslations.text('next'),
                  //             style: TextStyle(fontWeight: FontWeight.bold)),
                  //         onPressed: () {
                  //           setState(() {
                  //             if (currentIndexPage == 2) {
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => CountryPage()));
                  //             } else {
                  //               currentIndexPage++;
                  //             }
                  //             _controller.animateToPage(currentIndexPage,
                  //                 duration: _kDuration, curve: _kCurve);
                  //           });
                  //         },
                  //       ),
                  //       DotsIndicator(
                  //         dotsCount: pageLength,
                  //         position: currentIndexPage,
                  //         decorator: DotsDecorator(activeColor: Colors.green),
                  //       ),
                  //       FlatButton(
                  //         child: new Text(
                  //           allTranslations.text('skip'),
                  //           style: TextStyle(fontWeight: FontWeight.bold),
                  //         ),
                  //         onPressed: () {
                  //           Navigator.push(context,
                  //               MaterialPageRoute(builder: (context) => CountryPage()));
                  //         },
                  //       ),
                  //     ]),
                ),
              )
            ],
          ),
        ));
  }

  _indicator() {
    return Container(
      width: 120,
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xffDCDCDC)),
                value: 1,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xff53B553)),
                value: (currentIndexPage + 1) / (2 + 1),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                if (currentIndexPage == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                } else {
                  currentIndexPage++;
                }
                _controller.animateToPage(currentIndexPage,
                    duration: _kDuration, curve: _kCurve);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xff53B553),
                  borderRadius: BorderRadius.all(
                    Radius.circular(75),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _appBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        //    margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.only(top: 12),
        child: FlatButton(
          onPressed: () {
            if (currentIndexPage < 3)
              _controller.animateToPage(3,
                  duration: Duration(microseconds: 500),
                  curve: Curves.easeInOut);
          },
          child: Text(
            "Skip",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
