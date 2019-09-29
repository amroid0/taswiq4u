import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavroiteWidget extends StatefulWidget {
  @override
  _FavroiteWidgetState createState() => _FavroiteWidgetState();
}

class _FavroiteWidgetState extends State<FavroiteWidget> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: () {
          setState(() {
            _value = !_value;
          });
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), boxShadow:[ BoxShadow(blurRadius: 10,color: Colors.black26)], color: Colors.white),
          child: _value
              ? Icon(
            Icons.star_border,
            size: 30.0,
          )
              : Icon(
            Icons.star,
            size: 30.0,
            color: Colors.yellowAccent,
          ),
        ),
      );
  }
}
