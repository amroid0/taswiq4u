import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
AppBar appBar;
  @override
  Widget build(BuildContext context) {
    appBar=AppBar(
      title: Center(
        child: Text(allTranslations.text('personal_info'),textAlign: TextAlign.center,style: TextStyle(
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
                SizedBox(height: 24,),
                _BuildProifleImage(100,100),
                SizedBox(height: 8,),
                Text(allTranslations.text('change_profile'),style: TextStyle(color: Colors.black87,fontSize: 18,            decoration: TextDecoration.underline,
                ),),
                SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf),decoration: TextDecoration.none),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: allTranslations.text('first_name'),
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
                    ),
                    SizedBox(width: 10,),

                    Expanded(
                      child: TextField(
                          style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf),decoration: TextDecoration.none),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: allTranslations.text('sec_name'),
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
                    ),


                  ],

                ),

                SizedBox(height: 10,),
                TextField(
                    style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf),decoration: TextDecoration.none),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: allTranslations.text('email'),
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
                        hintText: allTranslations.text('phone'),
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
        ),
      ]
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
