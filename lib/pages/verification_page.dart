import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/verifcationBloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/pages/RestedPasswordPage.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/VerificationCodeInput.dart';

import 'main_page.dart';

class VerificationScreen extends StatefulWidget {
  final bool naviagteToResetPassword;
  final String phone;
  final int countryId;

  VerificationScreen(
      {this.naviagteToResetPassword = false, this.phone, this.countryId});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  VerifcationBloc bloc;

  String _code = "";

  var count = 0;
  var progressDialog;

  @override
  void initState() {
    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    bloc = VerifcationBloc();
    bloc.resendStream.listen((snap) {
      if (progressDialog.isShowing) {
        progressDialog.dismiss();
      }
      switch (snap.status) {
        case Status.LOADING:
          progressDialog.show();
          break;

        case Status.ERROR:
          Fluttertoast.showToast(
              msg: allTranslations.text('err_wrong'),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          break;

        case Status.COMPLETED:
          Fluttertoast.showToast(
              msg: allTranslations.text('code_sent'),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          break;
      }
    });
    bloc.stream.listen((data) {
      if (progressDialog.isShowing) {
        progressDialog.dismiss();
      }
      // Redirect to another view, given your condition
      switch (data.status) {
        case Status.LOADING:
          progressDialog.show();
          break;
        case Status.COMPLETED:
          var isVerify = data as ApiResponse<bool>;
          if (isVerify.data) {
            Fluttertoast.showToast(
                msg: allTranslations.text('verify_acc'),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            if (widget.naviagteToResetPassword) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ResetPasswordScreen(
                          widget.countryId, _code, widget.phone)));
            } else
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MainScreen()));
          }

          break;
        case Status.ERROR:
          Fluttertoast.showToast(
              msg: allTranslations.text('err_verify'),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
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
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(allTranslations.text('verify_label'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w500))),
                  Column(
                    children: <Widget>[
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: VerificationCodeInput(
                          length: 6,
                          keyboardType: TextInputType.phone,
                          onCompleted: (value) {
                            setState(() {
                              _code = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          bloc.verifyPhone(
                              _code, widget.phone, widget.countryId);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 65.0,
                          decoration: new BoxDecoration(
                            color: Colors.green,
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          child: Stack(children: <Widget>[
                            Align(
                              child: new Text(
                                allTranslations.text('verify'),
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              alignment: Alignment.center,
                            ),
                          ]),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(allTranslations.text('recive_code')),
                          TextButton(
                            onPressed: () {
                              bloc.resendCode(widget.countryId, widget.phone);
                            },
                            child: Text(
                              allTranslations.text('send_code'),
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ]))
          ]))
        ])));
  }
}
