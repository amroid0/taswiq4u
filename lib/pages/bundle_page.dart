import 'package:flutter/material.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';

class BundleScreen extends StatefulWidget {
  @override
  _BundleScreenState createState() => _BundleScreenState();
}

class _BundleScreenState extends State<BundleScreen> {
  AppBar appBar;
  @override
  Widget build(BuildContext context) {
    appBar=AppBar(
      title: Center(
        child: Text(allTranslations.text('bundle'),textAlign: TextAlign.center,style: TextStyle(
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
    child:GridView.builder(
    shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1,),
      itemBuilder: (contxt, indx){
        return Card(
          margin: EdgeInsets.all(4.0),
          child: Center(child:
          Column(
            children: <Widget>[
              Spacer(),
              Icon(Icons.announcement,size: 40,color: Colors.green,),
              Spacer(),
              Text(allTranslations.text('advert'),style: TextStyle(fontSize: 22,),),
              Spacer(),
              Text("${allTranslations.text('start')} 2500",style: TextStyle(fontSize: 14,color: Colors.black26),),
              Spacer(),
              Divider(color: Colors.grey,height: 1,),
              Spacer(),
Padding(
  padding: EdgeInsets.fromLTRB(16,4,16,4),
  child:   Container(

    height: 36,

    decoration: BoxDecoration(color: Color(0xEBECEDDD),),

    child: new Row(

      crossAxisAlignment:CrossAxisAlignment.stretch
,
    children: <Widget>[
      Expanded(
        child: new Container(

          child: new Icon(Icons.add, color: Colors.lightGreen,),

         ),
      ),



      Expanded(

        child: Padding(
          padding: EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: new Text('1day',

                style: new TextStyle(fontSize: 12.0,backgroundColor: Colors.white),
                textAlign: TextAlign.center,),
            ),
          ),
        ),

      ),

      Expanded(
        child: new Container(

          child: new Icon(
              const IconData(0xe15b, fontFamily: 'MaterialIcons'),
              color: Colors.lightGreen),

        ),
      ),

    ],





  )),
)



            ],


          )

          ),
        );
      },
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

