import 'package:flutter/material.dart';

class Walkthrougth extends StatelessWidget {
  final String textContent,textDetail;
  final String imagePath;
  Walkthrougth({Key key, @required this.textContent,this.imagePath, this.textDetail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
      <Widget>[
        
        Image.asset(imagePath),
        SizedBox(height: 10,),
        Text(textContent,style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        Text(textDetail,style: TextStyle(color:Colors.grey),)
        
        
        
        
        
      ],)),
    );
  }
}