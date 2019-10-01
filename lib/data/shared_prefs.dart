import 'package:olx/model/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
static final String KEY_IS_LOGGED="logged_in";
static final String KEY_SESSION="key_session";
static final String KEY_COUNTRY_ID="key_country";
static final String KEY_LANG="key_lang";
  Future<bool> isLoggedIn() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getBool(KEY_IS_LOGGED);
  }

  void setLoggedIn(LoginResponse user) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setBool(KEY_IS_LOGGED, true);
    instance.setString(KEY_SESSION, user.tokenType);

  }
Future<String> getToken(LoginResponse user) async {
  SharedPreferences instance = await SharedPreferences.getInstance();
  instance.getString(KEY_SESSION);

}
  void saveCountryID(String countryId)async{
    SharedPreferences instance =await SharedPreferences.getInstance();
        instance.setString(KEY_COUNTRY_ID, countryId);
  }
Future<String> getCountryCountryID(String countryId)async{
  SharedPreferences instance =await SharedPreferences.getInstance();
 return instance.getString(KEY_COUNTRY_ID);
}

  void saveLangauge(String lang)async{
    SharedPreferences instance =await SharedPreferences.getInstance();
        instance.setString(KEY_LANG, lang);
  }
  Future<String> getLang()async{
    SharedPreferences instance =await SharedPreferences.getInstance();
    return instance.getString(KEY_LANG);
  }

  void logout() async{
    SharedPreferences instance =await SharedPreferences.getInstance();
    instance.remove(KEY_IS_LOGGED);
    instance.remove(KEY_SESSION);
  }

}