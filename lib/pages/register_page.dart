import 'package:flutter/material.dart';
import 'package:olx/model/EventObject.dart';
import 'package:olx/remote/client_api.dart';
import 'package:olx/utils/Constants.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  ProgressDialog progressDialog ;
  String _email;
  String _password;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performRegister();
    }
  }

  void _performRegister() {
    // This is just a demo, so no actual login here.
    progressDialog = new ProgressDialog(context,ProgressDialogType.Normal);


    progressDialog.setMessage("Loading..");
    progressDialog.show();
    _registerUser(_email, _password);






  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
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
                      decoration: InputDecoration(labelText: 'Phone',
                        border: InputBorder.none,
                      ),
                      validator: (val) =>
                      !val.contains('0') ? 'Not a valid phone.' : null,
                      onSaved: (val) => _email = val,
                    ),
                  ),
                  SizedBox(height: 10,),

                  Container(
                    decoration: BoxDecoration(color:Colors.black12,border: Border.all(
                      width: 1.0,
                      color: Colors.green,


                    ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0) //         <--- border radius here
                      ),
                    ),
                    child: TextFormField(
                      key: passKey,
                      decoration: InputDecoration(labelText: 'Password',
                        border: InputBorder.none,
                      ),
                      validator: (val) =>
                      val.length < 6 ? 'Password too short.' : null,
                      onSaved: (val) => _password = val,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 10,),

                  Container(
              decoration: BoxDecoration(color:Colors.black12,border: Border.all(
                width: 1.0,
                color: Colors.green,


              ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //         <--- border radius here
                ),
              ),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password',
                  border: InputBorder.none,
                ),
                validator: (val) {
                var passsword = passKey.currentState.value;
              passsword==val ? null:'dosent match password.';
              },
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
            ),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: () =>_submit
                    ,
                    child: new Container(
                      height: 60.0,
                      padding: EdgeInsets.all(4),
                      decoration: new BoxDecoration(
                        color: Colors.green,
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child:  Stack(children:<Widget>[
                        Align( child: new Text('انشاء حساب', style: new TextStyle(fontSize: 18.0, color: Colors.white),)
                          ,alignment: Alignment.centerRight,),

                        Align( child:                 Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )    ,alignment: Alignment.centerLeft,),


                      ]

                      ),
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _registerUser(String id, String password) async {
    EventObject eventObject = await registerUser(id, password);
    switch (eventObject.id) {
      case EventConstants.USER_REGISTRATION_SUCCESSFUL:
        {
          setState(() {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text(SnackBarText.REGISTER_SUCCESSFUL),
            ));
            progressDialog.hide();
          });
        }
        break;
      case EventConstants.USER_REGISTRATION_UN_SUCCESSFUL:
        {
          setState(() {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text(SnackBarText.REGISTER_UN_SUCCESSFUL),
            ));
            progressDialog.hide();
          });
        }
        break;
      case EventConstants.NO_INTERNET_CONNECTION:
        {
          setState(() {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text(SnackBarText.NO_INTERNET_CONNECTION),
            ));
            progressDialog.hide();
          });
        }
        break;
    }
  }

}