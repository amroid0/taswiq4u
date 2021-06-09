
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
final String url;
ImageScreen(this.url);

@override
_MyImageScreen createState() => _MyImageScreen(url);
}

class _MyImageScreen extends State<ImageScreen> {
final String url;
_MyImageScreen(this.url);
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
),
body: Image.network(url, fit: BoxFit.fill,));
}
}