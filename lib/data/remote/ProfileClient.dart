

import 'dart:convert';

import 'package:olx/model/password_request_entity.dart';
import 'package:olx/model/userCredit.dart';
import 'package:olx/model/user_info.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class ProfileClient{
  Future<UserInfo>getUserData()async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.USER_PROFILE_API);
      final suggestions = results.data;
      return UserInfo.fromJson(suggestions);


  }

  Future<String?> updateUserData(UserInfo userInfo)  async{
  final results = await NetworkCommon()
      .dio
      .post(
  APIConstants.USER_UPDATE_API,data: jsonEncode(userInfo));
  if(results.statusCode==200){
  return "";
  }
}



  Future<String?> changePassword(PasswordRequest request)  async{
    final results = await NetworkCommon()
        .dio
        .post(
        APIConstants.PASSWORD_UPDATE_API,data: jsonEncode(request));
    if(results.statusCode==200){
      return "";
    }
  }





}