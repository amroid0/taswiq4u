import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavroiteWidget extends StatefulWidget {
  bool value = true;

  final Function(bool) onFavChange;

  FavroiteWidget({this.onFavChange,this.value});

  @override
  _FavroiteWidgetState createState() => _FavroiteWidgetState();
}

class _FavroiteWidgetState extends State<FavroiteWidget> {

  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: () {
          setState(() {
            widget.value = !widget.value;
            widget.onFavChange(widget.value);



          });
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), boxShadow:[ BoxShadow(blurRadius: 10,color: Colors.black26)], color: Colors.white),
          child: widget.value
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
