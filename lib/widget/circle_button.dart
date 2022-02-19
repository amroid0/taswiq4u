import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final IconData? iconData;
  final double? size,iconSize;

  const CircleButton({Key? key,this.size,this.iconSize, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}