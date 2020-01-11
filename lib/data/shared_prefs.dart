import 'dart:convert';

import 'package:olx/model/LoginResponse.dart';
import 'package:olx/model/userCredit.dart';
import 'package:shared_preferences/shared_preferences.dart';
SharedPreferencesHelper preferences = SharedPreferencesHelper();
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class SharedPreferencesHelper {
static final String KEY_IS_LOGGED="logged_in";
static final String KEY_SESSION="key_session";
static final String KEY_COUNTRY_ID="key_country";
static final String KEY_LANG="key_lang";
static final String KEY_CREDIT="key_username";

  Future<bool> isLoggedIn() async {
    SharedPreferences instance = await _prefs;
    return instance.getBool(KEY_IS_LOGGED);
  }

  void setLoggedIn(LoginResponse user) async {
    SharedPreferences instance = await _prefs;
    instance.setBool(KEY_IS_LOGGED, true);
    instance.setString(KEY_SESSION, user.tokenType);

  }
void saveCredit(UserCredit credit) async {
  SharedPreferences instance = await _prefs;
  instance.setString(KEY_CREDIT, json.encode(credit.toJson()));

}

Future<UserCredit> getUserCredit() async {
  SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_CREDIT);
  return UserCredit.fromJson(json.decode(stringJson));

}

  void setToken(LoginResponse user) async{
    SharedPreferences instance = await _prefs;
    instance.setString(KEY_SESSION, user.tokenType);
    instance.setBool(KEY_IS_LOGGED, true);

  }
Future<String> getToken() async {
  SharedPreferences instance = await _prefs;
  instance.getString(KEY_SESSION);

}
  void saveCountryID(String countryId)async{
    SharedPreferences instance =await _prefs;
        instance.setString(KEY_COUNTRY_ID, countryId);
  }
Future<String> getCountryCountryID(String countryId)async{
  SharedPreferences instance =await _prefs;
 return instance.getString(KEY_COUNTRY_ID);
}

  void saveLangauge(String lang)async{
    SharedPreferences instance =await _prefs;
        instance.setString(KEY_LANG, lang);
  }
  Future<String> getLang()async{
    SharedPreferences instance =await _prefs;
    return instance.getString(KEY_LANG);
  }

  void logout() async{
    SharedPreferences instance =await _prefs;
    instance.remove(KEY_IS_LOGGED);
    instance.remove(KEY_SESSION);
  }

static final SharedPreferencesHelper _preferences = SharedPreferencesHelper._internal();
factory SharedPreferencesHelper(){
  return _preferences;
}
SharedPreferencesHelper._internal();


}