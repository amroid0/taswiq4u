import 'package:olx/data/remote/ResetPasswordClient.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:rxdart/rxdart.dart';

import '../validator.dart';
import 'bloc.dart';

class ForgetPasswordBloc extends Validators implements Bloc {
  final _client = ResetPasswordClient();

  final _forgetController = BehaviorSubject<ApiResponse<bool>>();
  final _emailController =  BehaviorSubject<String>();
  final _countryController= BehaviorSubject<String>();


  Stream<ApiResponse<bool>> get forgetPasswordStream => _forgetController.stream;
  Stream<String> get country => _countryController.stream.transform(validateEmpty);
  Stream<String> get email => _emailController.stream.transform(validateEmail);
   String get emailValue=>_emailController.value;
  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, country, (dynamic e, dynamic p) {
        return true;
      });
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get chnageCountry => _countryController.sink.add;



  forgetPassword(int countryId) async{
    print("pasasasa22");
    final validEmail = _emailController.value;

    if(validEmail.isNotEmpty){
      print("pasasasa11");

        _forgetController.add(ApiResponse.loading('loading'));
        try {
          print("pasasasa2221");

          final results = await _client.forgetPassword(validEmail,countryId);
          if(results!=null){
            _forgetController.sink.add(ApiResponse.completed(results));
          }
        }catch(e){
      _forgetController.sink.add(ApiResponse.error(e.toString()));

        }

      }
  }


  @override
  void dispose() {
  }

}
