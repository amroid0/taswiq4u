import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/profile_bloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/user_info.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/loading_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AppBar appBar;
  TextEditingController firstController = TextEditingController();
  TextEditingController phoneContorller = TextEditingController();
  bool isupdated = false;
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<ProfileBloc>(context).getSavedLocalUserInfo();
    BlocProvider.of<ProfileBloc>(context).updateStream.listen((data) {
      // Redirect to another view, given your conditi on
      switch (data.status) {
        case Status.LOADING:
          Future.delayed(Duration.zero, () {
            DialogBuilder(context)
                .showLoadingIndicator(allTranslations.text('loading'));
          });
          break;
        case Status.COMPLETED:
          UserInfo info = data.data;
          if (info != null) {
            phoneContorller.text = info.phone;
            String name = info.firstName;
            if (info.secondName != null && info.secondName.isNotEmpty) {
              name += " ${info.secondName}";
            }
            firstController.text = name;
          }
          if (isupdated) {
            DialogBuilder(context).hideOpenDialog();
            Fluttertoast.showToast(
                msg: allTranslations.text('Success_update'),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(context);
          }

          break;
        case Status.ERROR:
          isupdated = false;
          DialogBuilder(context).hideOpenDialog();

          Fluttertoast.showToast(
              msg: "Something went Wrong'",
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
    appBar = AppBar(
      title: Center(
        child: Text(
          allTranslations.text('personal_info'),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black38),
        ),
      ),
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black38,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'back',
        ),
      ],
    );
    return Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: appBar,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildProfile(),
        ));
  }

  Widget _buildProfile() {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                _BuildProifleImage(100, 100),
                SizedBox(
                  height: 8,
                ),
                Text(
                  allTranslations.text('change_profile'),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 24),
                StreamBuilder(
                    stream: BlocProvider.of<ProfileBloc>(context).firstName,
                    builder: (context, snapshot) {
                      return TextField(
                          controller: firstController,
                          onChanged: BlocProvider.of<ProfileBloc>(context)
                              .changeFirstName,
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Color(0xFFbdc6cf),
                              decoration: TextDecoration.none),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              errorText: snapshot.error,
                              hintText: allTranslations.text('first_name'),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              )));
                    }),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: BlocProvider.of<ProfileBloc>(context).email,
                    builder: (context, snapshot) {
                      return TextField(
                          controller: phoneContorller,
                          onChanged:
                              BlocProvider.of<ProfileBloc>(context).changeEmail,
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Color(0xFFbdc6cf),
                              decoration: TextDecoration.none),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: allTranslations.text('phone'),
                              isDense: true,
                              errorText: snapshot.error,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              )));
                    }),
              ],
            ),
          ),
        ),
      ),
      StreamBuilder(
          stream: BlocProvider.of<ProfileBloc>(context).submitValid,
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<ProfileBloc>(context)
                    .changeFirstName(firstController.text);
                BlocProvider.of<ProfileBloc>(context)
                    .changeEmail(phoneContorller.text);

                if (firstController.text.isNotEmpty &&
                    phoneContorller.text.isNotEmpty) {
                  isupdated = true;
                  snapshot.hasError
                      ? null
                      : BlocProvider.of<ProfileBloc>(context)
                          .updateUserProfileInfo();
                }
              },
              child: Container(
                height: 70.0,
                decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                child: Stack(children: <Widget>[
                  Align(
                    child: new Text(
                      allTranslations.text('save_change'),
                      style: new TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    alignment: Alignment.center,
                  ),
                ]),
              ),
            );
          }),
    ]);
  }

  Widget _BuildProifleImage(double width, double height) {
    return CircleAvatar(
      radius: 70.0,
      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
      backgroundColor: Colors.grey,
    );
  }
}
