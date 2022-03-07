import 'dart:async';

import 'package:olx/data/shared_prefs.dart';
import 'package:olx/utils/global_locale.dart';

class RegisterValidators {

  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) async{
    String? countryId = await preferences.getCountryID() ;
    int c = int.parse(countryId!) ;
    String pattern = r"\b([\-]?\d[\-]?){11}\b";
    RegExp regExp = new RegExp(pattern);
    print(email);
    if (email.length>10&&c==1 ||email.length>7&&c==2) {
      sink.add(email);
    }

    else if (!regExp.hasMatch(email)) {
      sink.addError(c==1 ?allTranslations.text('err_email')!:allTranslations.text('err_numk')!);

    }else {
      sink.addError(c==1 ?allTranslations.text('err_email')!:allTranslations.text('err_numk')!);

    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length > 5) {
          sink.add(password);
        } else {
          sink.addError(allTranslations.text('err_pass')!);
        }
      });

  final validateConfirmPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length > 5) {
          sink.add(password);
        } else {
          sink.addError(allTranslations.text('err_pass_confirm')!);
        }
      });


  final validateFirstName = StreamTransformer<String, String>.fromHandlers(
      handleData: (firstName, sink) {
        final nameRegExp = new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
        final String name = firstName.replaceAll(RegExp(r'\u{200e}', unicode: true), '');

        if(firstName.isEmpty){
          sink.addError(allTranslations.text('err_fname')!);
        }

        if(nameRegExp.hasMatch(name.trim().toString())){
          print("true");
          sink.add(firstName);
        }
        else {
          print("false");

          sink.addError(allTranslations.text('err_fname')!);
        }
      });
  final validateSeocndName = StreamTransformer<String, String>.fromHandlers(
      handleData: (secondName, sink) {
        if (secondName.length >= 3) {
          sink.add(secondName);
        }else if(secondName.length==0){
          sink.addError(allTranslations.text('empty_field')!);
        }


        else {
          sink.addError(allTranslations.text('err_lname')!);
        }
      });
  final validateCountry = StreamTransformer<String, String>.fromHandlers(
      handleData: (secondName, sink) {
        if (secondName.length >= 3) {
          sink.add(secondName);
        }else if(secondName.length==0){
          sink.addError(allTranslations.text('empty_field')!);
        }


        else {
          sink.addError(allTranslations.text('err_lname')!);
        }
      });

}
