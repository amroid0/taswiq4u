import 'package:bmprogresshud/progresshud.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/model/EventObject.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/register_page.dart';
import 'package:olx/pages/verification_page.dart';
import 'package:olx/remote/client_api.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  TabController tabController ;// +added
  LoginPage(
      {this.tabController} // +added
      );
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ProgressDialog pr;
  var bloc;


  @override
  void initState() {
    // TODO: implement initState
  bloc=LoginBloc();
  bloc.stream.listen((snap) {

    switch (snap.status) {
      case Status.LOADING:
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(child: CircularProgressIndicator(),);
                }));
        return  Container();
        break;
      case Status.AUTHNTICATED:
        Navigator.of(context).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) =>  Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen())
          ));


        break;

      case Status.UNVERFIED:
        Navigator.of(context).pop();
        WidgetsBinding.instance.addPostFrameCallback((_) =>  Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerificationScreen())
        ));



        break;


      case Status.ERROR:
        WidgetsBinding.instance.addPostFrameCallback((_)  async {
          //pr.hide();
          // pr.hide();

          showSnackBar(context,'User Name Or Password is Wrong');




        });
        Navigator.of(context).pop();

        break;

      case Status.UNAUTHINTICATED:
        WidgetsBinding.instance.addPostFrameCallback((_)  async {
          //pr.hide();
          // pr.hide();

          showSnackBar(context,'User Name Or Password is Wrong');




        });
        Navigator.of(context).pop();

        break;
    }
  });


  super.initState();
  }


  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      bloc: bloc,
      child: Scaffold(
        key: scaffoldKey,

        body: ProgressHud(
          child: Center(

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset('images/logo.png'),
                    emailField(bloc),
                    SizedBox(height: 10,),
                     passwordField(bloc) ,
                    SizedBox(height: 10,),
                    submitButton(bloc),


                    InkWell(
                      onTap: (){
                      //  Navigator.push(context, MaterialPageRoute( builder: (context) => RegisterPage()));
                        widget.tabController.animateTo(1);
                      },
                      child: Padding(padding: EdgeInsets.all(10),
                      child: Text(allTranslations.text('register')),
                      ),

                    )


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget emailField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {

      return  Container(
          decoration: BoxDecoration(color:Colors.black12,border: Border.all(
            width: 1.0,
            color: Colors.green,


          ),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0) //         <--- border radius here
            ),
          ),
          child: TextFormField(
            keyboardType:TextInputType.numberWithOptions(),
            decoration: InputDecoration(labelText: allTranslations.text('phone'),filled: true,
              border: InputBorder.none,
              errorText: snapshot.error,

            ),
            onChanged: bloc.changeEmail,

          ),
        );

      },
    );
  }

  Widget submitButton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitValid,
        builder: (context, snapshot) {

      return GestureDetector(onTap: (){
      snapshot.hasError?null:bloc.submit();

      },
      child: Container(
        height: 60.0,
        padding: EdgeInsets.all(4),
        decoration: new BoxDecoration(
          color: Colors.green,
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child:  Stack(children:<Widget>[
          Align( child: new Text(allTranslations.text('login'), style: new TextStyle(fontSize: 18.0, color: Colors.white),)
            ,alignment: Alignment.centerRight,),

          Align( child: Icon(
            allTranslations.isEnglish?
            Icons.arrow_back: Icons.arrow_forward,
            color: Colors.white,
          )    ,alignment: Alignment.centerLeft,),


        ]

        ),
      )
      );});




  }


  Widget passwordField(LoginBloc bloc) {

    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {

          return Container(

            decoration: BoxDecoration(color:Colors.black12,border: Border.all(
              width: 1.0,
              color: Colors.green,


            ),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
              ),
            ),
            child: TextFormField(
              decoration: InputDecoration(labelText: allTranslations.text('password'),filled: true,
                fillColor: Colors.black12,
                border: InputBorder.none,
                errorText: snapshot.error,

              ),
              validator: (val) =>
              val.length < 6 ? allTranslations.text('err_short') : null,
              obscureText: true,
              onChanged: bloc.changePassword,

            ),
          );

        });
  }

  showSnackBar(BuildContext context,String message){

    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),

    );
    Scaffold.of(context).showSnackBar(snackBar);
  }




}
