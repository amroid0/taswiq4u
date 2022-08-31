import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';

class StarWidget extends StatefulWidget {
  bool value = true;

  final Function(bool) onFavChange;
  final Color iconColor;
  final Color bgColor;

  StarWidget({this.onFavChange,this.value,this.iconColor =Colors.black,this.bgColor=Colors.white});

  @override
  _StarWidgetState createState() => _StarWidgetState();
}

class _StarWidgetState extends State<StarWidget> {

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        if(widget.value) return;

          if(BlocProvider.of<LoginBloc>(context).isLogged()){
            widget.value = !widget.value;
          }
          widget.onFavChange(widget.value);





      },
      child: Container(
        height:35,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
         ),
        child: widget.value
            ?
        Icon(
          Icons.star,
          size: 30.0,
          color: Colors.amber,
        ): Icon(
          Icons.star_border,
          size: 30.0,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
