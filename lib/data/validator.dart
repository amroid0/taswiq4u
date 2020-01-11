import 'dart:async';

import 'package:olx/utils/global_locale.dart';

class Validators {
  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.length>0) {
      sink.add(email);
    } else {
      sink.addError(allTranslations.text('err_email'));
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length > 4) {
          sink.add(password);
        } else {
          sink.addError('err_pass');
        }
      });
}