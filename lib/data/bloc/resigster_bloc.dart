import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/register_client.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/userCredit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:olx/data/validator.dart';

class RegisterBloc extends Bloc with Validators{
  final _client = RegisterApiClient();

  final _controller = StreamController<ApiResponse<bool>>();

  final _phoneController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController=BehaviorSubject<String>();
  final _ConfirmPassword=BehaviorSubject<String>();
  Stream<ApiResponse<bool>> get stream => _controller.stream;
  Stream<String> get email => _phoneController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => CombineLatestStream.combine4(email,_nameController,_ConfirmPassword, password, (e, p,c,n) => true);
  Function(String) get changeEmail => _phoneController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get chnageConfrimPassword => _ConfirmPassword.sink.add;


  RegisterBloc();


  submit() async{
    final validEmail = _phoneController.value;
    final validPassword = _passwordController.value;
    final validname = _nameController.value;

    _controller.add(ApiResponse.loading('loading'));
    try {
      final results = await _client.register(UserCredit(validEmail,validPassword));
      _controller.sink.add(ApiResponse.completed(results));
    }catch(e){
      _controller.sink.add(ApiResponse.error(e.toString()));

    }
  }


  @override
  void dispose() {
    _nameController.close();
    _ConfirmPassword.close();
    _phoneController.close();
    _passwordController.close();
  }



}