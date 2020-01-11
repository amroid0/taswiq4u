import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/userCredit.dart';
import 'package:olx/utils/Constants.dart';

class LoginClient{

    Future<bool> login(UserCredit credit) async {
      final results = await NetworkCommon().dio.post(APIConstants.LOGIN,
        data: 'grant_type=password&username=${credit.userName}&password=${credit
            .password}',

      );
      if (results.statusCode == 200) {
        preferences.saveCredit(credit);
        return true;
      }
    }
}