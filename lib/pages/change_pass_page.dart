import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/profile_bloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/utils/dailogs.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/loading_dialog.dart';
import 'package:olx/widget/text_field_decoration.dart';

class ChnagePassScreen extends StatefulWidget {
  @override
  _ChnagePassScreenState createState() => _ChnagePassScreenState();
}

class _ChnagePassScreenState extends State<ChnagePassScreen> {
  AppBar appBar;
  TextEditingController curPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isupdated = false;
  @override
  void initState() {
    // TODO: implement initState

    BlocProvider.of<ProfileBloc>(context).passwordupdateStream.listen((data) {
      // Redirect to another view, given your conditi on
      switch (data.status) {
        case Status.LOADING:
          Future.delayed(Duration.zero, () {
            DialogBuilder(context).showLoadingIndicator('loading');
          });
          break;
        case Status.COMPLETED:
          if (isupdated) {
            DialogBuilder(context).hideOpenDialog();
            Fluttertoast.showToast(
                msg: "Successfully Updated'",
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
              msg: "old password  Wrong!'",
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
      title: Text(
        allTranslations.text('change_pass'),
        //  textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'back',
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
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
                  height: 16,
                ),
                StreamBuilder(
                    stream: BlocProvider.of<ProfileBloc>(context).curpassword,
                    builder: (context, snapshot) {
                      return TextFieldDecoration(
                        onChanged: BlocProvider.of<ProfileBloc>(context)
                            .changecurpassword,
                        textEditingController: curPasswordController,
                        //   style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf),decoration: TextDecoration.none),
                        //     decoration: InputDecoration(
                        errorText: snapshot.error,
                        //  filled: true,
                        fillColor: Colors.white,
                        labelText: allTranslations.text('current_pass'),
                        isDense: true,
                        isPassword: true,
                        //  contentPaddingVertical: const EdgeInsets.symmetric(horizontal:8,vertical: 20.0),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        //   borderSide: BorderSide(
                        //     width: 0,
                        //     style: BorderStyle.none,
                        //   ),
                        // )

                        //       )
                      );
                    }),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: BlocProvider.of<ProfileBloc>(context).newpassword,
                    builder: (context, snapshot) {
                      return TextFieldDecoration(
                        onChanged: BlocProvider.of<ProfileBloc>(context)
                            .changenewpassword,
                        textEditingController: newPasswordController,
                        // style: TextStyle(
                        //     fontSize: 22.0,
                        //     color: Color(0xFFbdc6cf),
                        //     decoration: TextDecoration.none),
                        //  decoration: InputDecoration(
                        errorText: snapshot.error,
                        isPassword: true,
                        //     filled: true,
                        fillColor: Colors.white,
                        labelText: allTranslations.text('new_pass'),
                        isDense: true,
                        contentPaddingVertical: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 20.0),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        //   borderSide: BorderSide(
                        //     width: 0,
                        //     style: BorderStyle.none,
                        //   ),
                        // )
                        // )
                      );
                    }),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream:
                        BlocProvider.of<ProfileBloc>(context).confirmpassword,
                    builder: (context, snapshot) {
                      return TextFieldDecoration(
                        onChanged: BlocProvider.of<ProfileBloc>(context)
                            .changeconfrimpassword,
                        textEditingController: confirmPasswordController,
                        // style: TextStyle(
                        //     fontSize: 22.0,
                        //     color: Color(0xFFbdc6cf),
                        //     decoration: TextDecoration.none),
                        //    decoration: InputDecoration(
                        errorText: snapshot.error,
                        isPassword: true,
                        //     filled: true,
                        fillColor: Colors.white,
                        labelText: allTranslations.text('confirm_pass'),
                        isDense: true,
                        contentPaddingVertical: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 20.0),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        //   borderSide: BorderSide(
                        //     width: 0,
                        //     style: BorderStyle.none,
                        //   ),
                        // )
                        //  )
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
      StreamBuilder(
          stream: BlocProvider.of<ProfileBloc>(context).submitValid,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 60,
                    child: Dialogs.commonButton(() {
                      BlocProvider.of<ProfileBloc>(context)
                          .changecurpassword(curPasswordController.text);
                      BlocProvider.of<ProfileBloc>(context)
                          .changenewpassword(newPasswordController.text);
                      BlocProvider.of<ProfileBloc>(context)
                          .changeconfrimpassword(
                              confirmPasswordController.text);
                      if (newPasswordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        BlocProvider.of<ProfileBloc>(context).passordNotMatch();
                        return;
                      }

                      if (curPasswordController.text.isNotEmpty &&
                          newPasswordController.text.isNotEmpty &&
                          confirmPasswordController.text.isNotEmpty) {
                        snapshot.hasError
                            ? null
                            : BlocProvider.of<ProfileBloc>(context)
                                .updatePassword();
                        isupdated = true;
                      }
                    }, allTranslations.text('save_change'))),
              ),
            );
            // return GestureDetector(
            //     onTap: () {
            //       BlocProvider.of<ProfileBloc>(context)
            //           .changecurpassword(curPasswordController.text);
            //       BlocProvider.of<ProfileBloc>(context)
            //           .changenewpassword(newPasswordController.text);
            //       BlocProvider.of<ProfileBloc>(context)
            //           .changeconfrimpassword(confirmPasswordController.text);
            //       if (newPasswordController.text.trim() !=
            //           confirmPasswordController.text.trim()) {
            //         BlocProvider.of<ProfileBloc>(context).passordNotMatch();
            //         return;
            //       }
            //
            //       if (curPasswordController.text.isNotEmpty &&
            //           newPasswordController.text.isNotEmpty &&
            //           confirmPasswordController.text.isNotEmpty) {
            //         snapshot.hasError
            //             ? null
            //             : BlocProvider.of<ProfileBloc>(context)
            //                 .updatePassword();
            //         isupdated = true;
            //       }
            //     },
            //     child: Container(
            //       height: 70.0,
            //       decoration: new BoxDecoration(
            //         color: Colors.green,
            //         borderRadius: new BorderRadius.circular(8.0),
            //       ),
            //       child: Stack(children: <Widget>[
            //         Align(
            //           alignment: Alignment.centerLeft,
            //           child: Row(
            //             children: [
            //               Icon(
            //                 allTranslations.isEnglish
            //                     ? Icons.arrow_back
            //                     : Icons.arrow_forward,
            //                 color: Colors.white,
            //               ),
            //               new Text(
            //                 allTranslations.text('save_change'),
            //                 style: new TextStyle(
            //                     fontSize: 18.0, color: Colors.white),
            //               ),
            //             ],
            //           ),
            //         )
            //       ]),
            //     ));
          })
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
