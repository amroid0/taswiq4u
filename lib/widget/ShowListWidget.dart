import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ShowListWidget extends StatefulWidget {
  int value = 1;

  final Function(int) onvalueChange;

  ShowListWidget({this.onvalueChange, this.value});

  @override
  _FavroiteWidgetState createState() => _FavroiteWidgetState();
}

class _FavroiteWidgetState extends State<ShowListWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      icon: Icon(
        MdiIcons.viewGrid,

      ),
      onPressed: () {
        if (widget.value == 1) {
          widget.value = 2;
        } else {
          widget.value = 1;
        }

        widget.onvalueChange(widget.value);
      },
    );
  }
}
