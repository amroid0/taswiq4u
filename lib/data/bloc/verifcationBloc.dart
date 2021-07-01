import 'package:olx/data/remote/VerifcationClient.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class VerifcationBloc   implements Bloc {
final _client = VerifcationClient();

final _controller = BehaviorSubject<ApiResponse<bool>>();
Stream<ApiResponse<bool>> get stream => _controller.stream;

VerifcationBloc();

verifyPhone(String code, String userPhone, int countryID) async{

  _controller.add(ApiResponse.loading('loading'));
  try {
    final userData=await preferences.getUserCredit();
    final requestPhone = userPhone??userData.userName;
    final requestCountryId = countryID??1;

    final results = await _client.verifyPhone(code,requestPhone,requestCountryId);
    if(results){
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


@override
void dispose() {
  _controller.close();

}
}
