import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/ProfileClient.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/user_info.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc  implements Bloc {

  final _client = ProfileClient();
  final _controller = BehaviorSubject<ApiResponse<UserInfo>>();

  Stream<ApiResponse<UserInfo>> get stream => _controller.stream;


  ProfileBloc();

  void getUserProfileInfo() async {
    _controller.sink.add(ApiResponse.loading('loading'));
    try {
      final results = await _client.getUserData();
      _controller.sink.add(ApiResponse.completed(results));

    }catch(e) {
      _controller.sink.add(ApiResponse.error(e.toString()));
    }}

  @override
  void dispose() {
    // TODO: implement dispose
  }
}