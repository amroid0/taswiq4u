import 'package:olx/data/shared_prefs.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class VerifcationClient{

  Future<bool?> verifyPhone(String code,String? userPhone,int countryID) async {


    final results = await NetworkCommon().dio.post(APIConstants.VERFIY_PHONE_API,
        data: {"VerificationCode":code,"Phone":userPhone,"CountryId":countryID}
    );
    if (results.statusCode == 200) {
       return true;
    }
  }


}