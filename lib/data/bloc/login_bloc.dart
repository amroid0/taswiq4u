import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/AuthClient.dart';
import 'package:olx/data/remote/ProfileClient.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/data/validator.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/app_exception.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/model/userCredit.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:rxdart/rxdart.dart';


class LoginBloc extends Validators implements Bloc {
final _client = AuthClient();
final _profileClient=ProfileClient();

final _controller = BehaviorSubject<LoginApiResponse<bool>>();
final _logincontroller = BehaviorSubject<bool>();

final _emailController = BehaviorSubject<String>();
final _passwordController = BehaviorSubject<String>();

  bool mIsLogged=false;
  bool isfirstPopupAd=true;
Stream<LoginApiResponse<bool>> get stream => _controller.stream;
Stream<bool> get Sessionstream => _logincontroller.stream;

Stream<String> get email => _emailController.stream.transform(validateEmpty);
Stream<String> get password => _passwordController.stream.transform(validateEmpty);
Stream<bool> get submitValid => CombineLatestStream.combine2(email, password, (e, p) => true);
Function(String) get changeEmail => _emailController.sink.add;
Function(String) get changePassword => _passwordController.sink.add;
bool isLogged() => mIsLogged==null?false:mIsLogged;


  LoginBloc(){
    checkAuth();
  }

  void checkAuth() async{
    mIsLogged=await preferences.isLoggedIn();
    _logincontroller.sink.add(mIsLogged);

  }

  submit() async{
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    if(validEmail.isEmpty||validPassword.isEmpty){
      return;

    }

    Stream.fromFuture(_client.login(UserCredit(validEmail,validPassword)))
        .flatMap((value)  {
      if(value){
       return Stream.fromFuture(_client.checkVerfiyPhone());
      }
      return Stream.error(UnauthorisedException());
    }).flatMap((value) {
      if(value){
        return Stream.fromFuture(_profileClient.getUserData());
      }
      return Stream.error(UnVerfiedException());
    })
        .doOnData((event) {preferences.saveUserData(event);})
        .doOnListen(() {    _controller.add(LoginApiResponse.loading('loading'));
    }).listen((event) {
      _controller.sink.add(LoginApiResponse.authenticate(""));
      _logincontroller.sink.add(true);
      mIsLogged=true;

    },onError: (e){
      if(e is UnVerfiedException){
        _controller.sink.add(LoginApiResponse.unverified("err"));

      }else if(e is UnauthorisedException){
        _controller.sink.add(LoginApiResponse.unAuthenticate("err"));

      }else {
        _controller.sink.add(LoginApiResponse.error(e.toString()));
      }
    });

    _controller.add(LoginApiResponse.loading('loading'));
      try {
     final results = await _client.login(UserCredit(validEmail,validPassword));
     if(results){
     final verifyResults = await _client.checkVerfiyPhone();
      if(verifyResults) {
        _controller.sink.add(LoginApiResponse.authenticate("err"));
        _logincontroller.sink.add(true);
        mIsLogged=true;
      }else
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

  void logout() async{
    preferences.logout();
    mIsLogged=false;
    _logincontroller.sink.add(false);
  }
}
