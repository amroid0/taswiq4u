import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/model/EventObject.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/pages/forget_password_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/register_page.dart';
import 'package:olx/pages/verification_page.dart';
import 'package:olx/remote/client_api.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/auth_input_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'main_page.dart';


class LoginPage extends StatefulWidget {
  TabController tabController ;// +added
  int home = 0 ;
  LoginPage(
      {this.tabController,this.home} // +added
      );
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ArsProgressDialog progressDialog;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final emailContoller=TextEditingController();
  final passwordContoller=TextEditingController();
 // static String nameLogin ;

  void getusernameee() async{
    print("streamEnterrr");
    LoginBloc.nameLogin = await APIConstants.getUserNameLogin();
    print("stream"+LoginBloc.nameLogin);
  }
  @override
  void initState() {

    progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
  BlocProvider.of<LoginBloc>(context).stream.listen((snap) {
    if(progressDialog.isShowing){
      progressDialog.dismiss();
    }
    switch (snap.status) {
      case Status.LOADING:
        progressDialog.show();
        break;
      case Status.AUTHNTICATED:
             widget.home==1 ? Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                 MainScreen()), (Route<dynamic> route) => false)
             :  Navigator.pop(context);
             getusernameee();

        break;

      case Status.UNVERFIED:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerificationScreen())
        );

        break;


      case Status.ERROR:

          showSnackBar(context,allTranslations.text('login_err'));




        break;

      case Status.UNAUTHINTICATED:
        showSnackBar(context,allTranslations.text('login_err'));


        break;
    }
  });


  super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      bloc: BlocProvider.of<LoginBloc>(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,

        body: ProgressHud(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Align(alignment:Alignment.center,child: Text(allTranslations.text('login'),
                    style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)),
                  SizedBox(height: 10,),
                  emailField(BlocProvider.of<LoginBloc>(context)),
                  SizedBox(height: 16,),
                   passwordField(BlocProvider.of<LoginBloc>(context)) ,
                  SizedBox(height: 16,),
                  submitButton(BlocProvider.of<LoginBloc>(context)),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                        //  Navigator.push(context, MaterialPageRoute( builder: (context) => RegisterPage()));
                          widget.tabController.animateTo(1);
                        },
                        child: Padding(padding: EdgeInsets.all(10),
                        child: Text(allTranslations.text('register')),
                        ),

                      ),
                      InkWell(
                          onTap: (){

                            Navigator.of(context)
                                .push(MaterialPageRoute(builder:
                                (ctx)=>ForgetPasswordScreen()));

                          },

                          child: Text(allTranslations.text('forget_pass')))
                    ],
                  )


                ],
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

      return AuthInputWidget(
        focusNode: _emailFocus,
        labelText: allTranslations.text('phone'),
        contoller: emailContoller,
        keyboardType:TextInputType.numberWithOptions(),
          errorText: snapshot.error,


        textInputAction: TextInputAction.next,
        onFieldSubmitted: (val){
          _fieldFocuseChange(context,_emailFocus,_passwordFocus);

        },
        onChange: bloc.changeEmail,

      );

      },
    );
  }

  Widget submitButton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitValid,
        builder: (context, snapshot) {

      return GestureDetector(onTap: (){
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        if(emailContoller.text.isEmpty||passwordContoller.text.isEmpty){
          return;
        }
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
          Align(
            alignment:Alignment.centerLeft,
            child: Row(
              children: [

                Icon(
                  allTranslations.isEnglish?
                  Icons.arrow_back: Icons.arrow_forward,
                  color: Colors.white,
                ),
                new Text(allTranslations.text('login'), style: new TextStyle(fontSize: 18.0, color: Colors.white),),
              ],
            ),
          )



        ]

        ),
      )
      );
        });




  }


  Widget passwordField(LoginBloc bloc) {

    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {
           return AuthInputWidget(
             focusNode: _passwordFocus,
            invisbleText: true,
             contoller: passwordContoller,

             labelText: allTranslations.text('password'),

               errorText: snapshot.error,

             onChange: bloc.changePassword,
             onFieldSubmitted: (val){
               _passwordFocus.unfocus();


             },
           );
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
              focusNode: _passwordFocus,
              decoration: InputDecoration(labelText: allTranslations.text('password'),filled: true,
                fillColor: Colors.black12,
                border: InputBorder.none,
                errorText: snapshot.error,

              ),
              validator: (val) =>
              val.length < 6 ? allTranslations.text('err_short') : null,
              obscureText: true,
              onChanged: bloc.changePassword,
              onFieldSubmitted: (val){
                _passwordFocus.unfocus();


              },
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


  _fieldFocuseChange(BuildContext context,FocusNode currentNode,FocusNode nextNode){

    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);

  }


}
