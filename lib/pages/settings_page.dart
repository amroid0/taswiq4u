import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/pages/change_pass_page.dart';
import 'package:olx/pages/edit_profile_page.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;

  var _langSelectedValue=1;

  var _countrySelectedValue=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: AppBar(
          title: Center(
            child: Text(allTranslations.text('settings'),textAlign: TextAlign.center,style: TextStyle(
                color:
                Colors.black38

            ),),
          ),

          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward_ios,color: Colors.black38,),
              onPressed: () {
                Navigator.pop(context);

              },
              tooltip: 'back',
            ),
          ],
        ),
        body:
        _buildSettings()

    );

  }
  Widget _buildSettings( ){
    return                Padding(
      padding:EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: SingleChildScrollView(


        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start
        ,
          children: [
            SizedBox(height: 24,),
            Text(allTranslations.text('account_setting'),style: TextStyle(color: Colors.green,fontSize: 24),),
            ListTile(leading: Icon(Icons.person),
              title: Text(allTranslations.text('personal_info')),
                trailing: Icon(Icons.arrow_forward_ios),

            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfileScreen() ,));

            },
            ),
            ListTile(leading: Icon(Icons.vpn_key),
              title: Text(allTranslations.text('change_pass')),
                trailing: Icon(Icons.arrow_forward_ios),

                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ChnagePassScreen() ,));

                }),
            SizedBox(height: 16,),
            Text(allTranslations.text('other'),style: TextStyle(color: Colors.green,fontSize: 24),),
            ListTile(leading: Icon(Icons.notifications),title: Text(allTranslations.text('notification')),
              trailing: CupertinoSwitch(
              value: isSwitched,
              onChanged: (value){
                setState(() {
                  isSwitched=value;
                  print(isSwitched);
                });
              },
              trackColor: Colors.grey,
              activeColor: Colors.green,
            ),),
            ListTile(leading: Icon(Icons.language),
              title: Text(allTranslations.text('lang')),
              trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){

              Alert(
                  context: context,
                  title: "",
                  buttons: [],
                  content: Column(
                    children: <Widget>[

                      Directionality(textDirection: TextDirection.rtl,

                        child: RadioListTile(
                          value: 1,
                          groupValue: _langSelectedValue,
                          title: Text("English",style: TextStyle(color: Colors.black),),
                          onChanged: (val) {
                            _langSelectedValue=val;
                            Navigator.of(context).pop();
                          },

                          selected: true,
                        ),
                      ),
                      Divider(height: 2,color: Colors.grey,),
                      Directionality(textDirection: TextDirection.rtl,

                        child: RadioListTile(
                          value: 2,
                          groupValue: _langSelectedValue,
                          title: Text("اللغه العربيه",style: TextStyle(color: Colors.black)),
                          onChanged: (val) {
                              _langSelectedValue=val;
                              Navigator.of(context).pop();
                          },

                          selected: true,

                        ),
                      ),
                    ],
                  ),
                 ).show();
            },
            ),
            ListTile(leading: Icon(Icons.language),
              title: Text(allTranslations.text('country')),
              trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){

              Alert(
                context: context,
                title: "",
                buttons: [],
                content: Column(
                  children: <Widget>[

                    Directionality(textDirection: TextDirection.rtl,

                      child: RadioListTile(
                        value: 1,
                        groupValue: _countrySelectedValue,
                        title: Text(allTranslations.text('page.egypt'),style: TextStyle(color: Colors.black),),
                        onChanged: (val) {
                            _countrySelectedValue=val;
                            Navigator.of(context).pop();

                        },

                        selected: true,
                      ),
                    ),
                    Divider(height: 2,color: Colors.grey,),
                    Directionality(textDirection: TextDirection.rtl,

                      child: RadioListTile(
                        value: 2,
                        groupValue: _countrySelectedValue,
                        title: Text(allTranslations.text('page.kuwait'),style: TextStyle(color: Colors.black)),
                        onChanged: (val) {
                           _countrySelectedValue=val;
                           Navigator.of(context).pop();
                        },

                        selected: true,

                      ),
                    ),
                  ],
                ),
              ).show();

            },)


          ],
        ),
      ),
    );




  }
}
