import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/resgister_bloc.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/pages/login_page.dart';
import 'package:olx/pages/verification_page.dart';
import 'package:olx/utils/dailogs.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/country_list_dialog.dart';
import 'package:olx/widget/text_field_decoration.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  final Function(int pos) onSelectionChanged; // +added
  RegisterPage({this.onSelectionChanged} // +added
      );

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final reigsterKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController phoneContorller = TextEditingController();
  TextEditingController passwordContoller = TextEditingController();
  final TextEditingController _countrytextController = TextEditingController();

  ArsProgressDialog progressDialog;
  String _email;
  String _password;
  RegisterBloc bloc;
  int countryId;
  int val = -1;

  @override
  void initState() {
    // TODO: implement initState
    bloc = RegisterBloc();

    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    bloc.stream.listen((data) {
      // Redirect to another view, given your condition
      if (progressDialog.isShowing) {
        progressDialog.dismiss();
      }
      switch (data.status) {
        case Status.LOADING:
          progressDialog.show();
          break;

        case Status.ERROR:
          Fluttertoast.showToast(
              msg: data.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case Status.AUTHNTICATED:
          // TODO: Handle this case.
          break;
        case Status.UNVERFIED:
          // TODO: Handle this case.
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerificationScreen(
                          countryId: val, phone: phoneContorller.text))));

          break;
        case Status.UNAUTHINTICATED:
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage())));
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
    return BlocProvider<RegisterBloc>(
      bloc: bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: reigsterKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${allTranslations.text('welcome')}!',
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
                          ' Create account to start your shopping \n journey on our application ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff818391),
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    firstName(bloc),
                    SizedBox(
                      height: 16,
                    ),
                    //  secondName(bloc),
                    phone(bloc),
                    SizedBox(
                      height: 16,
                    ),
                    password(bloc),
                    SizedBox(
                      height: 16,
                    ),
                    confrimPassword(bloc),
                    SizedBox(
                      height: 16,
                    ),
                    country(bloc),
                    SizedBox(
                      height: 32,
                    ),
                    submitButton(bloc),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${allTranslations.text('have_account')} ?',
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
                                    builder: (context) => LoginPage()));
                            // bloc.resendCode(widget.countryId, widget.phone);
                          },
                          child: Text(
                            allTranslations.text('login'),
                            style: TextStyle(
                                color: Color(0xff53B553),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    //  registerState(bloc)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

/*
  Widget registerState(RegisterBloc bloc){
    return StreamBuilder(
      stream: bloc.stream,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:

              WidgetsBinding.instance.addPostFrameCallback((_) =>pr.show());

              break;
            case Status.COMPLETED:
              pr.hide();
              var isLogged=snapshot.data as ApiResponse<bool>;
              var isss=isLogged.data;
              if(isss)
                WidgetsBinding.instance.addPostFrameCallback((_) =>showAlertDialog(context));

              break;
            case Status.ERROR:
              pr.hide();
              WidgetsBinding.instance.addPostFrameCallback((_) =>  showSnackBar(context,allTranslations.text('err_something_wrong')));
              break;
          }
        }
        return Container();


      },
    );

  }
*/

  Widget firstName(RegisterBloc bloc) {
    return StreamBuilder(
        stream: bloc.firstName,
        builder: (context, snapshot) {
          return TextFieldDecoration(
            labelText: allTranslations.text('first_name'),
            errorText: snapshot.error,
            onChanged: bloc.changeFirstName,
            textEditingController: firstController,
          );
        });
  }

  Widget phone(RegisterBloc bloc) {
    return StreamBuilder(
        stream: bloc.email,
        builder: (context, snapshot) {
          return TextFieldDecoration(
            labelText: allTranslations.text('phone'),
            errorText: snapshot.error,
            onChanged: bloc.changeEmail,
            textEditingController: phoneContorller,
            keyboardType: TextInputType.phone,
          );
        });
  }

  Widget country(RegisterBloc bloc) {
    return StreamBuilder(
        stream: bloc.country,
        builder: (context, snapshot) {
          return TextFieldDecoration(
            readOnly: true,
            textEditingController: _countrytextController,
            onTap: () {
              _showCountryD();
            },
            labelText: allTranslations.text('country'),
            errorText: snapshot.error,
            suffixIcon: Icon(Icons.arrow_drop_down),
            onChanged: bloc.chnageCountry,
          );
        });
  }

  Widget password(RegisterBloc bloc) {
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextFieldDecoration(
            labelText: allTranslations.text('password'),
            errorText: snapshot.error,
            isPassword: true,
            invisbleText: true,
            onChanged: bloc.changePassword,
            textEditingController: passwordContoller,
          );
        });
  }

  Widget confrimPassword(RegisterBloc bloc) {
    return StreamBuilder(
        stream: bloc.confrimPassword,
        builder: (context, snapshot) {
          return TextFieldDecoration(
            labelText: allTranslations.text('pass_confirm'),
            errorText: snapshot.error,
            isPassword: true,
            onSaved: (val) => _password = val,
            invisbleText: true,
            onChanged: bloc.chnageConfrimPassword,
          );
        });
  }

  Widget secondName(RegisterBloc bloc) {
    return StreamBuilder(
        stream: bloc.seocndName,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(
                width: 1.0,
                color: Colors.green,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
                  ),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: allTranslations.text('sec_name'),
                filled: true,
                fillColor: Colors.black12,
                border: InputBorder.none,
                errorText: snapshot.error,
              ),
              onChanged: bloc.changeSecondName,
              controller: lastController,
            ),
          );
        });
  }

  Widget submitButton(RegisterBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitValid,
        builder: (context, snapshot) {
          return Dialogs.commonButton(() {
            bloc.changeFirstName(firstController.text);
            bloc.changeEmail(phoneContorller.text);
            bloc.changePassword(passwordContoller.text);
            bloc.chnageCountry(_countrytextController.text);
            if (firstController.text.isNotEmpty &&
                phoneContorller.text.isNotEmpty &&
                passwordContoller.text.isNotEmpty)
              snapshot.hasError ? null : bloc.submit(val);
          }, 'Create Account');
          // return GestureDetector(
          //   onTap: () {
          //     bloc.changeFirstName(firstController.text);
          //     bloc.changeEmail(phoneContorller.text);
          //     bloc.changePassword(passwordContoller.text);
          //     bloc.chnageCountry(_countrytextController.text);
          //     if (firstController.text.isNotEmpty &&
          //         phoneContorller.text.isNotEmpty &&
          //         passwordContoller.text.isNotEmpty)
          //       snapshot.hasError ? null : bloc.submit(val);
          //   },
          //   child: Container(
          //     height: 70.0,
          //     padding: EdgeInsets.all(4),
          //     decoration: new BoxDecoration(
          //       color: Colors.green,
          //       borderRadius: new BorderRadius.circular(80.0),
          //     ),
          //     child: Stack(children: <Widget>[
          //       Align(
          //         alignment: Alignment.centerLeft,
          //         child: Row(
          //           children: [
          //             Icon(
          //               allTranslations.isEnglish
          //                   ? Icons.arrow_back
          //                   : Icons.arrow_forward,
          //               color: Colors.white,
          //             ),
          //             new Text(
          //               allTranslations.text('register'),
          //               style:
          //                   new TextStyle(fontSize: 18.0, color: Colors.white),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ]),
          //   ),
          // );
        });
  }

  _showCountryDialog() async {
    await CountryListDialog.showModal<CountryEntity>(context,
        label: allTranslations.text('choose_country'),
        selectedValue: CountryEntity(),
        items: List(), onChange: (CountryEntity selected) {
      setState(() {
        _countrytextController.text = allTranslations.isEnglish
            ? selected.englishDescription.toString()
            : selected.arabicDescription;
        countryId = selected.countryId;
      });
    });
  }

  Widget _showCountryD() {
    Alert(
        context: context,
        title: allTranslations.text('choose_country'),
        content: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) =>
                  Container(
            child: Column(children: <Widget>[
              RadioListTile(
                value: 1,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = value;
                    _countrytextController.text = allTranslations.text('egypt');
                  });
                },
                title: Text(allTranslations.text('egypt')),
              ),
              SizedBox(
                height: 20,
              ),
              RadioListTile(
                value: 2,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = value;
                    _countrytextController.text =
                        allTranslations.text('kuwait');
                  });
                },
                title: Text(allTranslations.text('kuwait')),
              ),
            ]),
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              allTranslations.text('ok'),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  showAlertDialog(BuildContext context) {
    return Alert(
      context: context,
      title: allTranslations.text('success'),
      desc: allTranslations.text('acc_created'),
      type: AlertType.success,
      buttons: [
        DialogButton(
          child: Text(
            allTranslations.text('ok'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
