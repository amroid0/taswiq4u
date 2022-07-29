import 'package:flutter/material.dart';

class Walkthrougth extends StatelessWidget {
  final String textContent, textDetail;
  final String imagePath;
  Widget dot;
  Walkthrougth(
      {Key key,
      @required this.textContent,
      this.imagePath,
      this.textDetail,
      this.dot})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          SizedBox(
            height: 5,
          ),
          dot,
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              textContent,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              textDetail,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      )),
    );
  }
}
