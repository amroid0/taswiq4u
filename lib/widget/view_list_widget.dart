import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';

class ViewListWidget extends StatefulWidget {
  bool value = true;

  final Function(bool) onFavChange;
  final Color iconColor;
  final Color bgColor;

  ViewListWidget({this.onFavChange,this.value,this.iconColor =Colors.black,this.bgColor=Colors.white});

  @override
  _ViewListWidgetState createState() => _ViewListWidgetState();
}

class _ViewListWidgetState extends State<ViewListWidget> {

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
        height:35,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
        ),
        child: widget.value
            ?
        Icon(
          MdiIcons.viewGrid,
          size: 30.0,
          color: Color(0xff2D3142),
        ): Icon(
          Icons.view_list,
          size: 30.0,
          color: Color(0xff2D3142),
        ),
      ),
    );
  }
}
