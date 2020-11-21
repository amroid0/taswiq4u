

import 'package:olx/model/user_info.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class ProfileClient{
  Future<UserInfo>getUserData()async{
    final results = await NetworkCommon()
        .dio
        .get(
        APIConstants.USER_PROFILE_API);
    if(results.statusCode==200){
      final suggestions = results.data;
      return UserInfo.fromJson(suggestions);
    }

  }

}