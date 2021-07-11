import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/ForgetPasswordBloc.dart';
import 'package:olx/data/bloc/Reset_password_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/pages/verification_page.dart';
import 'package:olx/utils/ToastUtils.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/auth_input_widget.dart';
import 'package:olx/widget/country_list_dialog.dart';

class ResetPasswordScreen extends  StatefulWidget {
  final int countryId;
  final String token;
  final String phone;
  ResetPasswordScreen(this. countryId,this. token,this. phone);

  @override
  _ResetPassPageState createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPasswordScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ArsProgressDialog progressDialog;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  var _bloc;

  var _countrytextController=TextEditingController();

  int countryId;

  var count=0;

  @override
  void initState() {
    _bloc=ResetPasswordBloc();
    progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    _bloc.resetPasswordStream.listen((snap) {
      if(progressDialog.isShowing){
        progressDialog.dismiss();
      }
      switch (snap.status) {
        case Status.LOADING:
          progressDialog.show();
          break;


        case Status.ERROR:



          ToastUtils.
          showErrorMessage(
              allTranslations.text('err_wrong'));


          break;

        case Status.COMPLETED:

          ToastUtils.
          showSuccessMessage(allTranslations.text('success_reset_pass'));
          WidgetsBinding.instance.addPostFrameCallback((_) =>  Navigator.popUntil(context, (route) {
            return count++ == 3;
          }));

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
    return BlocProvider<ResetPasswordBloc>(
      bloc: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,

        body:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(alignment:Alignment.center,
                    child: Text(allTranslations.text('password_recovery'),
                      style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)),

                SizedBox(height: 10,),
                password(_bloc),
                SizedBox(height: 16,),
                confrimPassword(_bloc) ,
                SizedBox(height: 16,),
                submitButton(_bloc),
              ],
            ),
          ),
        ),

      ),
    );
  }



  Widget password(ResetPasswordBloc bloc){
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {

          return AuthInputWidget(
            labelText: allTranslations.text('new_password'),
            errorText: snapshot.error,

            invisbleText: true,
            onChange: bloc.changePassword,

          );

        });

  }

  Widget confrimPassword(ResetPasswordBloc bloc){
    return StreamBuilder(
        stream: bloc.confrimPassword,
        builder: (context, snapshot) {

          return AuthInputWidget(

            labelText: allTranslations.text('pass_confirm'),
            errorText: snapshot.error,
            invisbleText: true,
            onChange: bloc.chnageConfrimPassword,


          );

        });

  }

  Widget submitButton(ResetPasswordBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitValid,
        builder: (context, snapshot) {

          return GestureDetector(onTap: (){
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            if(snapshot.data!=null&&snapshot.data)
              bloc.resetPassword(widget.token,widget.countryId,widget.phone);

          },
              child: Container(
                height: 60.0,
                padding: EdgeInsets.all(4),
                decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child:  Stack(children:<Widget>[
                  Align( child: new Text(allTranslations.text('password_recovery'), style: new TextStyle(fontSize: 18.0, color: Colors.white),)
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



  showSnackBar(BuildContext context,String message){

    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),

    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }


  _fieldFocuseChange(BuildContext context,FocusNode currentNode,FocusNode nextNode){

    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);

  }


}
