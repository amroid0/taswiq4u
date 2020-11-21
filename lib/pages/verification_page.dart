import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/verifcationBloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/loading_dialog.dart';
import 'package:olx/widget/VerificationCodeInput.dart';

import 'main_page.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}




class _VerificationScreenState extends State<VerificationScreen> {
  VerifcationBloc bloc;

  String _code="";

  
  @override
  void initState() {

    bloc =VerifcationBloc();

    bloc.stream.listen((data) {
      // Redirect to another view, given your condition
      switch (data.status) {
        case Status.LOADING:
          Future.delayed(Duration.zero, () {
            DialogBuilder(context).showLoadingIndicator('Verifying...');

          });
          break;
        case Status.COMPLETED:
          DialogBuilder(context).hideOpenDialog();



          var isVerify=data as ApiResponse<bool>;
          if(isVerify.data){

            Fluttertoast.showToast(
                msg: "Verified'",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );

            WidgetsBinding.instance.addPostFrameCallback((_) =>  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen())
            ));
            
            
          }

          break;
        case Status.ERROR:
          DialogBuilder(context).hideOpenDialog();

          Fluttertoast.showToast(
              msg: "Something went Wrong'",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          break;
      }
    });
    
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
            Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
            Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
            Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Enter 6 digits verification code sent to your number', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w500))
        ),
     Column(
       children: <Widget>[
         VerificationCodeInput(
           length: 6,
           keyboardType: TextInputType.number,
          onCompleted: (value){
            setState(() {
              _code = value;
            });
          },
         ),
         SizedBox(height: 16,),


         Container(
           margin: const EdgeInsets.symmetric(horizontal: 20),
           height: 70.0,
           decoration: new BoxDecoration(
             color: Colors.green,
             borderRadius: new BorderRadius.circular(8.0),
           ),
           child:  Stack(children:<Widget>[
             Align( child: new Text("تفعيل", style: new TextStyle(fontSize: 18.0, color: Colors.white),)
               ,alignment: Alignment.center,),



           ]

           ),
         ),

       ],

     )
                ])
            )
                ])
            )])
        ));

  }
}




