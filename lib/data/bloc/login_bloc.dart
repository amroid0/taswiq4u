import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/validator.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/userCredit.dart';
import 'package:rxdart/rxdart.dart';

import '../remote/login_client.dart';

class LoginBloc extends Validators implements Bloc {
final _client = LoginClient();

final _controller = StreamController<ApiResponse<bool>>();

final _emailController = BehaviorSubject<String>();
final _passwordController = BehaviorSubject<String>();
Stream<ApiResponse<bool>> get stream => _controller.stream;
Stream<String> get email => _emailController.stream.transform(validateEmail);
Stream<String> get password => _passwordController.stream.transform(validatePassword);
Stream<bool> get submitValid => CombineLatestStream.combine2(email, password, (e, p) => true);
Function(String) get changeEmail => _emailController.sink.add;
Function(String) get changePassword => _passwordController.sink.add;


  LoginBloc();


  submit() async{
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;

    _controller.add(ApiResponse.loading('loading'));
      try {
     final results = await _client.login(UserCredit(validEmail,validPassword));
    _controller.sink.add(ApiResponse.completed(results));
    }catch(e){
    _controller.sink.add(ApiResponse.error(e.toString()));

    }
  }


@override
void dispose() {
_emailController.close();
_passwordController.close();
  }
}
