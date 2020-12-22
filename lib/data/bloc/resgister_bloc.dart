import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/registerValidator.dart';
import 'package:olx/data/remote/AuthClient.dart';
import 'package:olx/model/RegisterRequest.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:olx/model/userCredit.dart';
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
  Stream<String> get firstName => _firstNameController.stream.transform(validateFirstName);
  Stream<String> get seocndName => _secondNameController.stream.transform(validateSeocndName);
  Stream<String> get country => _countryController.stream.transform(validateCountry);

  Stream<bool> get submitValid => CombineLatestStream.combine4(email,firstName, password,country, (e, p,c,z) => true);
  Function(String) get changeEmail => _phoneController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Function(String) get changeSecondName => _secondNameController.sink.add;
  Function(String) get chnageConfrimPassword => _ConfirmPassword.sink.add;
  Function(String) get chnageCountry => _countryController.sink.add;

  RegisterBloc();

  submit(int countryId) async{
    final validEmail = _phoneController.value;
    final validPassword = _passwordController.value;
    final validFirstName = _firstNameController.value;
    List<String>namePattern=validFirstName.split(" ");
    String lang=await preferences.getLang();
    String country=await preferences.getCountryID();
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
          secondName: namePattern.length<=1?"":namePattern[1]
      ));
      if(results){
        _getToken(validEmail, validPassword);
      }

    }catch(e){
      _regiseterController.sink.add(LoginApiResponse.error(e.toString()));
    }
  }
  void _getToken(String phone,String pass) async{
    try{
      final tokenResult=await _client.login(new UserCredit(phone, pass));
      if(tokenResult){
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