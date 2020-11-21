import 'package:olx/data/shared_prefs.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class VerifcationClient{

  Future<bool> verifyPhone(String code) async {
    final userData = await preferences.getUserCredit();

    final results = await NetworkCommon().dio.post(APIConstants.VERFIY_PHONE_API,
        data: {"VerificationCode":code,"Phone":userData.userName}
    );
    if (results.statusCode == 200) {
       return true;
    }
  }


}