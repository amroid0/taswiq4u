import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/ProfileClient.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/user_info.dart';
import 'package:rxdart/rxdart.dart';

import '../shared_prefs.dart';

class ProfileBloc  implements Bloc {

  final _client = ProfileClient();
  final _controller = BehaviorSubject<ApiResponse<UserInfo>>();

  Stream<ApiResponse<UserInfo>> get stream => _controller.stream;


  ProfileBloc();

  void getUserProfileInfo() async {


    Stream.fromFuture(preferences.getUserInfo())
        .onErrorResume((error) => Stream.fromFuture(_client.getUserData()) .doOnData((event) {preferences.saveUserData(event);}))

        .doOnListen(() {        _controller.sink.add(ApiResponse.loading('loading'));
    }).listen((event) {
      _controller.sink.add(ApiResponse.completed(event));


    },onError: (e){
      _controller.sink.add(ApiResponse.error(e.toString()));

    });



    }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}