import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/AuthClient.dart';
import 'package:olx/data/validator.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/model/userCredit.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:rxdart/rxdart.dart';


class LoginBloc extends Validators implements Bloc {
final _client = AuthClient();

final _controller = BehaviorSubject<LoginApiResponse<bool>>();
final _emailController = BehaviorSubject<String>();
final _passwordController = BehaviorSubject<String>();
Stream<LoginApiResponse<bool>> get stream => _controller.stream;
Stream<String> get email => _emailController.stream.transform(validateEmpty);
Stream<String> get password => _passwordController.stream.transform(validateEmpty);
Stream<bool> get submitValid => CombineLatestStream.combine2(email, password, (e, p) => true);
Function(String) get changeEmail => _emailController.sink.add;
Function(String) get changePassword => _passwordController.sink.add;

  LoginBloc();

  submit() async{
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    if(validEmail.isEmpty||validPassword.isEmpty){
      return;

    }

    _controller.add(LoginApiResponse.loading('loading'));
      try {
     final results = await _client.login(UserCredit(validEmail,validPassword));
     if(results){
     final verifyResults = await _client.checkVerfiyPhone();
      if(verifyResults)
       _controller.sink.add(LoginApiResponse.authenticate("err"));
        else
        _controller.sink.add(LoginApiResponse.unverified("err"));
      }else{
       _controller.sink.add(LoginApiResponse.unAuthenticate("err"));
     }
      }
      catch(e){
    _controller.sink.add(LoginApiResponse.error(e.toString()));

    }
  }


@override
void dispose() {
_emailController.close();
_passwordController.close();
_controller.close();

  }
}
