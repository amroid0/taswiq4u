import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';

class FavroiteWidget extends StatefulWidget {
  bool value = true;

  final Function(bool) onFavChange;
  final Color iconColor;
  final Color bgColor;

  FavroiteWidget({this.onFavChange,this.value,this.iconColor =Colors.black,this.bgColor=Colors.white});

  @override
  _FavroiteWidgetState createState() => _FavroiteWidgetState();
}

class _FavroiteWidgetState extends State<FavroiteWidget> {

  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: () {
          setState(() {
            if(BlocProvider.of<LoginBloc>(context).isLogged()){
              widget.value = !widget.value;
            }
            widget.onFavChange(widget.value);




          });
        },
        child: Container(
          height:35,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
             ),
          child: widget.value
              ?
               Icon(
            Icons.favorite_rounded,
            size: 30.0,
            color: Colors.red,
          ): Icon(
            Icons.favorite_border,
            size: 30.0,
            color: widget.iconColor,
          ),
        ),
      );
  }
}
