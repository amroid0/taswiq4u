import 'package:olx/data/remote/ResetPasswordClient.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:rxdart/rxdart.dart';

import '../registerValidator.dart';
import 'bloc.dart';

class ResetPasswordBloc extends RegisterValidators implements Bloc {
  final _client = ResetPasswordClient();

  final _resetController = BehaviorSubject<ApiResponse<bool>>();
  final _ConfirmPassword=BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<String> get confrimPassword => _ConfirmPassword.stream.transform(validateConfirmPassword).doOnData((String c) {
    if (0 != _passwordController.value.compareTo(c)) {
      // If they do not match, add an error
      _ConfirmPassword.addError(allTranslations.text('err_pass_confirm'));
    }});

  Stream<ApiResponse<bool>> get resetPasswordStream => _resetController.stream;

  Stream<bool> get submitValid =>
      Rx.combineLatest2(password, confrimPassword, (e, p) {
        return true;
      });
  Function(String) get changePassword => _passwordController.sink.add;
    Function(String) get chnageConfrimPassword => _ConfirmPassword.sink.add;




  resetPassword(String token,int countryId,String phone) async{
    final validPass = _passwordController.value;

    if(validPass.isNotEmpty){

      _resetController.add(ApiResponse.loading('loading'));
      try {

        final results = await _client.resetPassword(token,validPass,phone,countryId);
        if(results){
          _resetController.sink.add(ApiResponse.completed(results));
        }
      }catch(e){
        _resetController.sink.add(ApiResponse.error(e.toString()));

      }

    }
  }


  @override
  void dispose() {
  }

}
