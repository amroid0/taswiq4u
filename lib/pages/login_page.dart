import 'package:bmprogresshud/progresshud.dart';
import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/model/EventObject.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/register_page.dart';
import 'package:olx/remote/client_api.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ProgressDialog progressDialog ;


  var bloc;

  String _password;
@override
  void initState() {
    // TODO: implement initState
  bloc=LoginBloc();


    super.initState();
  }
  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performLogin();
    }
  }

  void _performLogin() {
    // This is just a demo, so no actual login here.
    progressDialog = new ProgressDialog(context,ProgressDialogType.Normal);


     progressDialog.setMessage("Loading..");
     progressDialog.show();






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
                     loginState(bloc),


                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute( builder: (context) => RegisterPage()));

                      },
                      child: Padding(padding: EdgeInsets.all(10),
                      child: Text('Register'),
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
  Widget loginState(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.stream,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              ProgressHud.of(context).show(ProgressHudType.loading, "loading...");
           return  Container();
              break;
            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) =>  ProgressHud.of(context).showAndDismiss(ProgressHudType.success, "load success"));


              var isLogged=snapshot.data as ApiResponse<bool>;
                  var isss=isLogged.data;
               if(isss)
                 WidgetsBinding.instance.addPostFrameCallback((_) =>  Navigator.pushReplacement(
                     context,
                     MaterialPageRoute(builder: (context) => MainScreen())
                 ));



              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) => ProgressHud.of(context).showAndDismiss(ProgressHudType.error, "load fail"));
         break;
          }
        }
        return Container();


      },
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
            decoration: InputDecoration(labelText: 'Phone',filled: true,
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

      return RaisedButton(onPressed: (){
      snapshot.hasError?null:bloc.submit();

      },
      child: Text('login'),
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
              decoration: InputDecoration(labelText: 'Password',filled: true,
                fillColor: Colors.black12,
                border: InputBorder.none,
                errorText: snapshot.error,

              ),
              validator: (val) =>
              val.length < 6 ? 'Password too short.' : null,
              onSaved: (val) => _password = val,
              obscureText: true,
              onChanged: bloc.changePassword,

            ),
          );

        });
  }

  _showErrorMessage(errorMessage) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorMessage.toString()),));

  }
}
