import 'package:ars_dialog/ars_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/ForgetPasswordBloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/pages/verification_page.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/auth_input_widget.dart';
import 'package:olx/widget/country_list_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ForgetPasswordScreen extends  StatefulWidget {

@override
_ForgetPassPageState createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPasswordScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late CustomProgressDialog progressDialog;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  ForgetPasswordBloc? _bloc;

  var _countrytextController=TextEditingController();
  int? val = -1;
  int? countryId;

  @override
  void initState() {
_bloc=ForgetPasswordBloc();
    progressDialog = CustomProgressDialog(context,blur: 10);
    _bloc!.forgetPasswordStream.listen((snap) {
        progressDialog.dismiss();

      switch (snap.status) {
        case Status.LOADING:
          progressDialog.show();
          break;


        case Status.ERROR:

          Fluttertoast.showToast(
              msg: allTranslations.text('err_wrong')!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );



          break;

        case Status.COMPLETED:
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerificationScreen(
                naviagteToResetPassword: true,
                countryId: 1,
                phone: _bloc!.emailValue,

              ))
          );



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
    return BlocProvider<ForgetPasswordBloc?>(
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
                     child: Text(allTranslations.text('password_recovery')!,
               style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),)),

                 SizedBox(height: 10,),
                 emailField(_bloc!),
                 SizedBox(height: 16,),
                 country(_bloc!) ,
                 SizedBox(height: 16,),
                 submitButton(_bloc!),
               ],
              ),
            ),
          ),

      ),
    );
  }



  Widget emailField(ForgetPasswordBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {

        return AuthInputWidget(
          focusNode: _emailFocus,
          labelText: allTranslations.text('phone'),

          keyboardType:TextInputType.numberWithOptions(),
          errorText: snapshot.error as String?,


          textInputAction: TextInputAction.next,
          onFieldSubmitted: (val){
            _fieldFocuseChange(context,_emailFocus,_passwordFocus);

          },
          onChange: bloc.changeEmail,

        );

      },
    );
  }


  Widget? _showCountryD(){
    Alert(
        context: context,
        title: allTranslations.text('choose_country'),
        content: StatefulBuilder(
          builder:(BuildContext context,
              void Function(void Function()) setState) =>
              Container(
                child: Column(
                    children: <Widget>[
                      RadioListTile(
                        value: 1,
                        groupValue: val,
                        onChanged: (dynamic value) {
                          setState(() {
                            val = value;
                            _countrytextController.text =allTranslations.text('egypt')!;
                          });
                        },
                        title: Text(allTranslations.text('egypt')!),
                      ),
                      SizedBox(height: 20,),
                      RadioListTile(
                        value: 2,
                        groupValue: val,
                        onChanged: (dynamic value) {
                          setState(() {
                            val = value;
                            _countrytextController.text =allTranslations.text('kuwait')!;
                          });
                        },
                        title: Text(allTranslations.text('kuwait')!),
                      ),

                    ]
                ),
              ),
        ),
        buttons: [
          DialogButton(
            onPressed: (){
              Navigator.pop(context);

            },
            child: Text(
              allTranslations.text('ok')!,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]
    ).show();
  }
  Widget country(ForgetPasswordBloc bloc ){
    return StreamBuilder(
        stream: bloc.country,
        builder: (context, snapshot) {

          return  AuthInputWidget(


            readOnly: true,
            contoller: _countrytextController,
            onTap: (){
              _showCountryD();
            },
            labelText: allTranslations.text('country'),
            errorText: snapshot.error as String?,
            suffixIcon:  Icon(Icons.arrow_drop_down),


            onChange: bloc.chnageCountry,

          );

        });

  }

  Widget submitButton(ForgetPasswordBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitValid,
        builder: (context, snapshot) {

          return GestureDetector(onTap: (){
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            if(snapshot.data!=null)
              print("pasasasa");
             bloc.forgetPassword(1);

          },
              child: Container(
                height: 60.0,
                padding: EdgeInsets.all(4),
                decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child:  Stack(children:<Widget>[
                  Align( child: new Text(allTranslations.text('password_recovery')!, style: new TextStyle(fontSize: 18.0, color: Colors.white),)
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
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }


  _fieldFocuseChange(BuildContext context,FocusNode currentNode,FocusNode nextNode){

    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);

  }


}
