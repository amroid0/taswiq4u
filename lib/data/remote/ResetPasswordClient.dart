import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class ResetPasswordClient{
  Future<bool> forgetPassword(String userPhone,int countryID) async {


    final results = await NetworkCommon().dio.post(APIConstants.FORGET_PASS_API,
        data: {"Phone":userPhone,"CountryId":countryID}
    );
    if (results.statusCode == 200) {
      return true;
    }
  }

  Future<bool> resetPassword(String token,String password,String userPhone,int countryID) async {


    final results = await NetworkCommon().dio.post(APIConstants.RESET_PASS_API,
        data: {
          "NewPassword": password,
          "ConfirmPassword": password,
          "Token": token,
          "Phone": userPhone,
          "CountryId": countryID
        }
    );
    if (results.statusCode == 200) {
      return true;
    }
  }



}