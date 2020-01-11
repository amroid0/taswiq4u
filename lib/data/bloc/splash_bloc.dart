 import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/splash_client.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/model/api_response_entity.dart';

import '../shared_prefs.dart';

class SplashBloc  implements Bloc {
 final _client = SplashClient();
 final _controller = StreamController<ApiResponse<bool>>();
 final sessionManager = SharedPreferencesHelper();

 Stream<ApiResponse<bool>> get stream => _controller.stream;
 SplashBloc();
 void checkIsLogged() async {
   _controller.add(ApiResponse.loading('loading'));
   bool isLogged=await sessionManager.isLoggedIn();
   if(isLogged==null||!isLogged){
     _controller.add(ApiResponse.completed(false));
   }else {
     try {
       final results = await _client.updateToken(await sessionManager.getUserCredit());
       _controller.sink.add(ApiResponse.completed(results));
     }catch(e){
       _controller.sink.add(ApiResponse.error(e.toString()));

     }
   }
 }



 @override
 void dispose() {
   _controller.close();
 }
 }

