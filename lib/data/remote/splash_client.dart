import 'package:olx/model/userCredit.dart';
import 'package:olx/utils/Constants.dart';

import 'NetworkCommon.dart';

class SplashClient{

Future<bool> updateToken(UserCredit credit) async {
    final results = await NetworkCommon().dio.post(APIConstants.LOGIN,
  data: 'grant_type=password&username=${credit.userName}&password=${credit.password}',

    );
    if(results.statusCode==200){
      return true;
    }

   }

 }