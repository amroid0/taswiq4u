import 'package:olx/data/remote/VerifcationClient.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class VerifcationBloc   implements Bloc {
final _client = VerifcationClient();

final _controller = BehaviorSubject<ApiResponse<bool>>();
Stream<ApiResponse<bool>> get stream => _controller.stream;

VerifcationBloc();

verifyPhone(String code) async{

  _controller.add(ApiResponse.loading('loading'));
  try {
    final results = await _client.verifyPhone(code);
    if(results)
      _controller.sink.add(ApiResponse.completed(results));
  }catch(e){
    _controller.sink.add(ApiResponse.error(e.toString()));

  }
}


@override
void dispose() {
  _controller.close();

}
}
