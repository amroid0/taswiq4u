import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/pages/forget_password_page.dart';
import 'package:olx/pages/register_page.dart';
import 'package:olx/pages/verification_page.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/dailogs.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/text_field_decoration.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  TabController tabController; // +added
  int home = 0;

  LoginPage({this.tabController, this.home} // +added
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
  final emailContoller = TextEditingController();
  final passwordContoller = TextEditingController();

  // static String nameLogin ;

  void getusernameee() async {
    print("streamEnterrr");
    LoginBloc.nameLogin = await APIConstants.getUserNameLogin();
    print("stream" + LoginBloc.nameLogin);
  }

  @override
  void initState() {
    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    BlocProvider.of<LoginBloc>(context).stream.listen((snap) {
      if (progressDialog.isShowing) {
        progressDialog.dismiss();
      }
      switch (snap.status) {
        case Status.LOADING:
          progressDialog.show();
          break;
        case Status.AUTHNTICATED:
          widget.home == 1
              ? Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false)
              : Navigator.pop(context);
          getusernameee();

          break;

        case Status.UNVERFIED:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => VerificationScreen()));

          break;

        case Status.ERROR:
          showSnackBar(context, allTranslations.text('login_err'));

          break;

        case Status.UNAUTHINTICATED:
          showSnackBar(context, allTranslations.text('login_err'));

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
        //  key: scaffoldKey,
        body: ProgressHud(
          //  key: scaffoldKey,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 16.0, right: 4.0, left: 4.0, bottom: 16.0),
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${allTranslations.text('welcome_back')} !',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        ' Login to your account to start your shopping \n journey on our application ',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff818391),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  emailField(BlocProvider.of<LoginBloc>(context)),
                  SizedBox(
                    height: 16,
                  ),
                  passwordField(BlocProvider.of<LoginBloc>(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ForgetPasswordScreen()));
                          },
                          child: Text(allTranslations.text('forget_pass'),
                              style: TextStyle(
                                  color: Color(0xff53B553),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)))
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  submitButton(BlocProvider.of<LoginBloc>(context)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${allTranslations.text('donot_have_acc')} ?",
                        style: TextStyle(
                            color: Color(0xff818391),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                          // bloc.resendCode(widget.countryId, widget.phone);
                        },
                        child: Text(
                          allTranslations.text('register'),
                          style: TextStyle(
                              color: Color(0xff53B553),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
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
        return TextFieldDecoration(
          focusNode: _emailFocus,
          labelText: allTranslations.text('phone'),
          textEditingController: emailContoller,
          keyboardType: TextInputType.numberWithOptions(),
          // errorText: snapshot.error,
          validator: (value) {
            if (value.isEmpty) {
              return allTranslations.text('empty_field');
            } else {
              return null;
            }
          },
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (val) {
            _fieldFocuseChange(context, _emailFocus, _passwordFocus);
          },
          onChanged: bloc.changeEmail,
        );
      },
    );
  }

  Widget submitButton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitValid,
        builder: (context, snapshot) {
          return Dialogs.commonButton(() {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            if (formKey.currentState.validate()) {
              bloc.submit();
            }
            //  snapshot.hasError ? null : bloc.submit();
          }, allTranslations.text('login'));
          // return GestureDetector(
          //     onTap: () {
          //       SystemChannels.textInput.invokeMethod('TextInput.hide');
          //       if (emailContoller.text.isEmpty ||
          //           passwordContoller.text.isEmpty) {
          //         return;
          //       }
          //       snapshot.hasError ? null : bloc.submit();
          //     },
          //     child: Container(
          //       height: 70.0,
          //       padding: EdgeInsets.all(4),
          //       decoration: new BoxDecoration(
          //         color: Colors.green,
          //         borderRadius: new BorderRadius.circular(80.0),
          //       ),
          //       child: Stack(children: <Widget>[
          //         Align(
          //           alignment: Alignment.centerLeft,
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               new Text(
          //                 allTranslations.text('login'),
          //                 style: new TextStyle(
          //                     fontSize: 18.0, color: Colors.white),
          //               ),
          //             ],
          //           ),
          //         )
          //       ]),
          //     ));
        });
  }

  String _descAdsValidate(String value) {
    if (value.isEmpty) {
      return allTranslations.text('empty_field');
    } else {
      return null;
    }
  }

  Widget passwordField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextFieldDecoration(
            focusNode: _passwordFocus,
            keyboardType: TextInputType.text,
            invisbleText: true,
            isPassword: true,
            textAlign: TextAlign.center,
            textEditingController: passwordContoller,
            // contoller: passwordContoller,
            labelText: allTranslations.text('password'),
            errorText: snapshot.error,
            onChanged: bloc.changePassword,
            fillColor: Colors.white,
            onFieldSubmitted: (val) {
              _passwordFocus.unfocus();
            },
          );
          // return Container(
          //   decoration: BoxDecoration(
          //     color: Colors.black12,
          //     border: Border.all(
          //       width: 1.0,
          //       color: Colors.green,
          //     ),
          //     borderRadius: BorderRadius.all(
          //         Radius.circular(5.0) //         <--- border radius here
          //         ),
          //   ),
          //   child: TextFormField(
          //     focusNode: _passwordFocus,
          //     decoration: InputDecoration(
          //       labelText: allTranslations.text('password'),
          //       filled: true,
          //       fillColor: Colors.black12,
          //       border: InputBorder.none,
          //       errorText: snapshot.error,
          //     ),
          //     validator: (val) =>
          //         val.length < 6 ? allTranslations.text('err_short') : null,
          //     obscureText: true,
          //     onChanged: bloc.changePassword,
          //     onFieldSubmitted: (val) {
          //       _passwordFocus.unfocus();
          //     },
          //   ),
          // );
        });
  }

  showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _fieldFocuseChange(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }
}
