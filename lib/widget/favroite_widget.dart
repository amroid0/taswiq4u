import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';

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
            if(BlocProvider.of<LoginBloc>(context).isLogged()){
              widget.value = !widget.value;
            }
            widget.onFavChange(widget.value);




          });
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              boxShadow:[ BoxShadow(blurRadius: 4,color: Colors.black26)], color: Colors.white),
          child: widget.value
              ?
               Icon(
            Icons.favorite_rounded,
            size: 30.0,
            color: Colors.red,
          ): Icon(
            Icons.favorite_border,
            size: 30.0,
          ),
        ),
      );
  }
}
