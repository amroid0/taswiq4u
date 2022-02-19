import 'dart:convert';

import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {
  final String? imgSrc;
  final String defaultImg;
  final BoxFit boxFit;
  ImageBox({
    required this.imgSrc,
    required this.defaultImg,
    this.boxFit = BoxFit.fill,
  });
  @override
  Widget build(BuildContext context) {
   try{
    return imgSrc == null || imgSrc!.isEmpty
        ? Image.asset(
      defaultImg,
      fit: boxFit,
    )
        : Image.memory(
      base64Decode(imgSrc!),
      fit: boxFit,
    );
  }catch(e){
     return Image.asset(
       defaultImg,
       fit: boxFit,
     );
   }
  }
}