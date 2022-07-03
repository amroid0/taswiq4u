import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }

  static Widget commonButton(Function onTap, text,
      {width = double.maxFinite,
      height,
      color = 0xff53B553,
      textColor,
      fontSize,
      key,
      bool isLoading,
      radiusCircular = 80,
      double loadingHeight = 20.0,
      var horizontalPadding,
      borderColor}) {
    return InkWell(
        key: key,
        onTap: () => onTap(),
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(5.0),
                border:
                    borderColor == null ? null : Border.all(color: borderColor),
                borderRadius: BorderRadius.all(
                    Radius.circular(double.parse(radiusCircular.toString()))),
                color: Color(color)),
            height: height == null ? 60 : height.toDouble(),
            width: width.toDouble(),
            child: Container(
                child: SizedBox(
                    height: height == null ? 60 : height.toDouble(),
                    width: width.toDouble(),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding == null
                                ? 10
                                : double.parse(horizontalPadding.toString())),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              isLoading != null && isLoading
                                  ? SizedBox(height: loadingHeight, width: 88)
                                  : Text(text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: textColor ?? Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: fontSize == null
                                              ? 18
                                              : fontSize.toDouble()))
                            ]))))));
  }
}
