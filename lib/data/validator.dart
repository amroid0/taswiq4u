import 'dart:async';

import 'package:olx/utils/global_locale.dart';
import 'package:olx/data/shared_prefs.dart';

class Validators {

  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink)  async {
    String countryId = await (preferences.getCountryID() as FutureOr<String>) ;
    int c = int.parse(countryId) ;
    if (email.length>10&&c==1 ||email.length>7&&c==2) {
      sink.add(email);
    } else {
      sink.addError(c==1 ?allTranslations.text('err_email')!:allTranslations.text('err_numk')!);
    }
  });
  final validateEmpty =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.length>0) {
      sink.add(email);
    } else {
      sink.addError(allTranslations.text('err_empty')!);
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
  final validateFirstName = StreamTransformer<String, String>.fromHandlers(
      handleData: (firstName, sink) {
        if (firstName.length >= 3) {
          sink.add(firstName);
        }else if(firstName.length==0) {
          sink.addError(allTranslations.text('err_fname')!);
        }else if(firstName.split(" ").length<=1){
          sink.addError(allTranslations.text('err_secondname')!);

        }


        else {
          sink.addError(allTranslations.text('err_fname')!);
        }
      });
  final validateSeocndName = StreamTransformer<String, String>.fromHandlers(
      handleData: (secondName, sink) {
        if (secondName.length >= 3) {
          sink.add(secondName);
        } else if(secondName.length==0) {
        sink.addError(allTranslations.text('err_fname')!);
        }

        else {
          sink.addError(allTranslations.text('err_lname')!);
        }
      });

}