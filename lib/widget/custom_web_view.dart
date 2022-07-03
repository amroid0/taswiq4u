import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  MyWebView({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.70),

          body: Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: Container(
              padding: EdgeInsets.only(top: 30),

              decoration: BoxDecoration(
                color: Color(0xffBABABA),
                borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Text(allTranslations.text('cancel'),

                        style: TextStyle(color: AppColors.accentColor,fontSize: 16),),
                      ),
                    title: Center(
                      child: Text(title,
                        style: TextStyle(color:Color(0xff2D3142),fontSize: 17)),
                    ),
                    ),
                    Expanded(
                      child: WebView(
                        initialUrl: selectedUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController webViewController) {
                          _controller.complete(webViewController);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}