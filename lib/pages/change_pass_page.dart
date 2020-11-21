import 'package:flutter/material.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';

class ChnagePassScreen extends StatefulWidget {
  @override
  _ChnagePassScreenState createState() => _ChnagePassScreenState();
}

class _ChnagePassScreenState extends State<ChnagePassScreen> {
  AppBar appBar;
  @override
  Widget build(BuildContext context) {
    appBar=AppBar(
      title: Center(
        child: Text(allTranslations.text('change_pass'),textAlign: TextAlign.center,style: TextStyle(
            color:
            Colors.black38

        ),),
      ),

      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_forward_ios,color: Colors.black38,),
          onPressed: () {
            Navigator.pop(context);

          },
          tooltip: 'back',
        ),
      ],
    );
    return Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: appBar,
        body:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildProfile(),
        )

    );

  }
  Widget _buildProfile( ){
    return                Column(
        children:[ Expanded(
          child: SingleChildScrollView(


            child: Center(
              child: Column(

                children: [
                  SizedBox(height: 16,),
                  TextField(
                      style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf),decoration: TextDecoration.none),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: allTranslations.text('current_pass'),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal:8,vertical: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          )


                      )


                  ),

                  SizedBox(height: 10,),

                  TextField(
                      style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf),decoration: TextDecoration.none),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: allTranslations.text('new_pass'),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal:8,vertical: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          )


                      )


                  ),
                  SizedBox(height: 10,),
                  TextField(
                      style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf),decoration: TextDecoration.none),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: allTranslations.text('confirm_pass'),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal:8,vertical: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          )


                      )


                  ),



                ],
              ),
            ),
          ),
        ),
          Container(
            height: 70.0,
            decoration: new BoxDecoration(
              color: Colors.green,
              borderRadius: new BorderRadius.circular(8.0),
            ),
            child:  Stack(children:<Widget>[
              Align( child: new Text(allTranslations.text('save_change'), style: new TextStyle(fontSize: 18.0, color: Colors.white),)
                ,alignment: Alignment.center,),



            ]

            ),
          ),]
    );




  }

  Widget _BuildProifleImage(double width,double height){
    return CircleAvatar(
      radius: 70.0,
      backgroundImage:
      NetworkImage('https://via.placeholder.com/150'),
      backgroundColor: Colors.grey,
    );
  }

}
