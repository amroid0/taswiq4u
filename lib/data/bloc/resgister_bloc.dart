import 'dart:async';

import 'package:dio/dio.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/registerValidator.dart';
import 'package:olx/data/remote/AuthClient.dart';
import 'package:olx/model/RegisterRequest.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/app_exception.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/model/userCredit.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:rxdart/rxdart.dart';

import '../shared_prefs.dart';

class RegisterBloc extends Bloc with RegisterValidators{
  final _client = AuthClient();

  final _regiseterController = BehaviorSubject<LoginApiResponse<bool>>();
  final _phoneController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _firstNameController=BehaviorSubject<String>();
  final _secondNameController=BehaviorSubject<String>();
  final _countryController=BehaviorSubject<String>();

  final _ConfirmPassword=BehaviorSubject<String>();
  Stream<LoginApiResponse<bool>> get stream => _regiseterController.stream;
  Stream<String> get email => _phoneController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<String> get confrimPassword => _ConfirmPassword.stream.transform(validateConfirmPassword).doOnData((String c){
 if (0 != _passwordController.value.compareTo(c)){
      // If they do not match, add an error
   _ConfirmPassword.addError(allTranslations.text('err_pass_confirm')!);

 }


  });
  Stream<String> get firstName => _firstNameController.stream.transform(validateFirstName);
  Stream<String> get seocndName => _secondNameController.stream.transform(validateSeocndName);
  Stream<String> get country => _countryController.stream.transform(validateCountry);

  Stream<bool> get submitValid => CombineLatestStream.combine5(email,firstName, password,country,confrimPassword, (dynamic e, dynamic p,dynamic c,dynamic z,dynamic cp) =>  (0 == c.compareTo(cp)));
  Function(String) get changeEmail => _phoneController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Function(String) get changeSecondName => _secondNameController.sink.add;
  Function(String) get chnageConfrimPassword => _ConfirmPassword.sink.add;
  Function(String) get chnageCountry => _countryController.sink.add;

  RegisterBloc();

  submit(int? countryId) async{
    final validEmail = _phoneController.value.toString();
    final validPassword = _passwordController.value.toString();
    final validFirstName = _firstNameController.value.trim();
    List<String>namePattern=validFirstName.split(" ");
    String? lang=await preferences.getLang();
    int langID=lang==null ||lang=='en'?1:2;
    _regiseterController.add(LoginApiResponse.loading('loading'));
    try {
      final results =await _client.register(RegisterRequest(phone: validEmail,
        password: validPassword,
        confirmPassword: validPassword,
        languageId: langID,
        cityId: 1,
        countryId:countryId,
          firstName:namePattern[0],
          secondName: namePattern.length<=1?"":namePattern[namePattern.length-1]
      ));
      if(results){
        _getToken(validEmail, validPassword);
      }

    }catch(e){
      if(e is DioError) {
        if(e.response!.statusCode==500)
        _regiseterController.sink.add(
            LoginApiResponse.error(allTranslations.text('server_err')));
      else if (e.response!.statusCode==400)
        _regiseterController.sink.add(
            LoginApiResponse.error(allTranslations.text('account_exist')));
    }else
        _regiseterController.sink.add(LoginApiResponse.error(allTranslations.text('general_err')));
    }
  }
  void _getToken(String phone,String pass) async{
    try{
      final tokenResult=await _client.login(new UserCredit(phone, pass));
      if(tokenResult!=null){
        _regiseterController.sink.add(LoginApiResponse.unverified("err"));

      }else{
        _regiseterController.sink.add(LoginApiResponse.unAuthenticate("err"));

      }
    }catch(e){
      _regiseterController.sink.add(LoginApiResponse.unAuthenticate(e.toString()));

    }
    
    
  }


  @override
  void dispose() {
    _firstNameController.close();
    _secondNameController.close();
    _ConfirmPassword.close();
    _phoneController.close();
    _passwordController.close();
    _regiseterController.close();

  }



}