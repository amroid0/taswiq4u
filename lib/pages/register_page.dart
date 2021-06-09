import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/resgister_bloc.dart';
import 'package:olx/data/validator.dart';
import 'package:olx/model/EventObject.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/pages/login_page.dart';
import 'package:olx/pages/verification_page.dart';
import 'package:olx/remote/client_api.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/loading_dialog.dart';
import 'package:olx/widget/auth_input_widget.dart';
import 'package:olx/widget/city_list_dialog.dart';
import 'package:olx/widget/country_list_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  final Function(int pos) onSelectionChanged; // +added
  RegisterPage(
      {this.onSelectionChanged} // +added
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

  @override
  void initState() {
    // TODO: implement initState
    bloc=RegisterBloc();

    progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    bloc.stream.listen((data) {
      // Redirect to another view, given your condition
      if(progressDialog.isShowing){
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
              fontSize: 16.0
          );
          break;
        case Status.AUTHNTICATED:
          // TODO: Handle this case.
          break;
        case Status.UNVERFIED:
          // TODO: Handle this case.
          WidgetsBinding.instance.addPostFrameCallback((_) =>  Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => VerificationScreen())
          ));

          break;
        case Status.UNAUTHINTICATED:
          WidgetsBinding.instance.addPostFrameCallback((_) =>  Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage())
          ));
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
                    Align(alignment:Alignment.center,child: Text(allTranslations.text('register'),
                      style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)),
                    SizedBox(height: 10,),
                    firstName(bloc),
                    SizedBox(height: 16,),
                  //  secondName(bloc),
                    phone(bloc),
                    SizedBox(height: 16,),
                    password(bloc),
                    SizedBox(height: 16,),
                    confrimPassword(bloc),
                    SizedBox(height: 16,),
                    country(bloc),
                    SizedBox(height: 16,),
                    submitButton(bloc),
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

          return AuthInputWidget(


             labelText: allTranslations.text('first_name'),
                    errorText: snapshot.error,
              onChange: bloc.changeFirstName,
              contoller: firstController,

          );

        });
  }

  Widget phone(RegisterBloc bloc ){
    return StreamBuilder(
        stream: bloc.email,
        builder: (context, snapshot) {

          return AuthInputWidget(


             labelText: allTranslations.text('phone'),

                errorText: snapshot.error,

              onChange: bloc.changeEmail,
              contoller: phoneContorller,

          );

        });

  }

  Widget country(RegisterBloc bloc ){
    return StreamBuilder(
        stream: bloc.country,
        builder: (context, snapshot) {

          return AuthInputWidget(


              readOnly: true,
              contoller: _countrytextController,
              onTap: (){
                _showCountryDialog();
              },
              labelText: allTranslations.text('country'),
                errorText: snapshot.error,
                suffixIcon:  Icon(Icons.arrow_drop_down),


              onChange: bloc.chnageCountry,

          );

        });

  }
  Widget password(RegisterBloc bloc){
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {

          return AuthInputWidget(
         labelText: allTranslations.text('password'),
                errorText: snapshot.error,

              invisbleText: true,
              onChange: bloc.changePassword,
              contoller: passwordContoller,

          );

        });

  }

  Widget confrimPassword(RegisterBloc bloc){
    return StreamBuilder(
        stream: bloc.confrimPassword,
        builder: (context, snapshot) {

          return AuthInputWidget(

       labelText: allTranslations.text('pass_confirm'),
                errorText: snapshot.error,


              onSaved: (val) => _password = val,
              invisbleText: true,
              onChange: bloc.chnageConfrimPassword,


          );

        });

  }



  Widget secondName(RegisterBloc bloc) {

    return StreamBuilder(
        stream: bloc.seocndName,
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
              decoration: InputDecoration(labelText: allTranslations.text('sec_name'),filled: true,
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

          return GestureDetector(onTap: (){

            bloc.changeFirstName(firstController.text);
            bloc.changeEmail(phoneContorller.text);
            bloc.changePassword(passwordContoller.text);
            bloc.chnageCountry(_countrytextController.text);
            if(firstController.text.isNotEmpty
            &&
            phoneContorller.text.isNotEmpty&& passwordContoller.text.isNotEmpty)
            snapshot.hasError?null:bloc.submit(countryId);
          },
            child: Container(
              height: 60.0,
              padding: EdgeInsets.all(4),
              decoration: new BoxDecoration(
                color: Colors.green,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child:  Stack(children:<Widget>[
                Align( child: new Text(allTranslations.text('register'), style: new TextStyle(fontSize: 18.0, color: Colors.white),)
                  ,alignment: Alignment.centerRight,),

                Align( child:                 Icon(
                  allTranslations.isEnglish?Icons.arrow_back:Icons.arrow_forward,
                  color: Colors.white,
                )    ,alignment: Alignment.centerLeft,),


              ]

              ),
            ),
          );});

  }




  _showCountryDialog() async{
    await  CountryListDialog.showModal<CountryEntity>(
        context,
        label: allTranslations.text('choose_country'),
    selectedValue: CountryEntity(),
    items: List(),
    onChange: (CountryEntity selected) {
    _countrytextController.text=allTranslations.isEnglish?selected.englishDescription.toString():selected.arabicDescription;
   countryId=selected.countryId;});
  }

    showAlertDialog(BuildContext context) {
  return  Alert(
      context: context,
      title: allTranslations.text('success'),
      desc: allTranslations.text('acc_created')
      ,
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


  showSnackBar(BuildContext context,String message){

    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),

    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}