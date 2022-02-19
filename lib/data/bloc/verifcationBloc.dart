import 'package:olx/data/bloc/Reset_password_bloc.dart';
import 'package:olx/data/remote/ResetPasswordClient.dart';
import 'package:olx/data/remote/VerifcationClient.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class VerifcationBloc   implements Bloc {
final _client = VerifcationClient();
final _resetClient = ResetPasswordClient();


final _controller = BehaviorSubject<ApiResponse<bool>>();

  final _resendController= BehaviorSubject<ApiResponse<bool>>();
Stream<ApiResponse<bool>> get stream => _controller.stream;
Stream<ApiResponse<bool>> get resendStream => _resendController.stream;

VerifcationBloc();

verifyPhone(String code, String? userPhone, int? countryID) async{

  _controller.add(ApiResponse.loading('loading'));
  try {
    final userData=await preferences.getUserCredit();
    final requestPhone = userPhone??userData.userName;
    final requestCountryId = countryID??1;

    final results = await _client.verifyPhone(code,requestPhone,requestCountryId);
    if(results!=null){
      // Not reset verification
      if(userPhone==null){
       preferences.setAccountAcivation(true);
      }
      _controller.sink.add(ApiResponse.completed(results));
    }
  }catch(e){
    _controller.sink.add(ApiResponse.error(e.toString()));

  }
}


resendCode(int? countryId,String? userPhone) async{


    _resendController.add(ApiResponse.loading('loading'));
    try {

      final results = await _resetClient.forgetPassword(userPhone,countryId);
      if(results!=null){
        _resendController.sink.add(ApiResponse.completed(results));
      }
    }catch(e){
      _resendController.sink.add(ApiResponse.error(e.toString()));

    }


}





@override
void dispose() {
  _controller.close();

}
}
