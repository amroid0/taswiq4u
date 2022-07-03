import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';

class FavroiteWidgetCard extends StatefulWidget {
  bool value = true;

  final Function(bool) onFavChange;

  FavroiteWidgetCard({this.onFavChange,this.value});

  @override
  _FavroiteWidgetCardState createState() => _FavroiteWidgetCardState();
}

class _FavroiteWidgetCardState extends State<FavroiteWidgetCard> {

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
      child: widget.value
          ?
      Icon(
        Icons.favorite_rounded,
        size: 24.0,
        color: Color(0xffCE0700),
      ): Icon(
        Icons.favorite_outline,
        size: 24.0,
      ),
    );
  }
}
