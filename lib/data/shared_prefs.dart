import 'dart:convert';

import 'package:olx/model/LoginResponse.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/country_entity.dart';
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
static final String KEY_CATEGORY="key_cat";
static final String KEY_LIKED="key_liked";
static final String KEY_VIEWD="key_viewed";
static final String KEY_COUNTRY="country_key";
 static final String KEY_COUNTRY_LIST="count_list_key";

  static final String KEY_CITY_LIST="key_city_list";

  Future<bool> isLoggedIn() async {
    SharedPreferences instance = await _prefs;
    return instance.getBool(KEY_IS_LOGGED);
  }

  void setLoggedIn(LoginResponse user) async {
    SharedPreferences instance = await _prefs;
    instance.setBool(KEY_IS_LOGGED, true);
    instance.setString(KEY_SESSION, user.accessToken);

  }
void saveCredit(UserCredit credit) async {
  SharedPreferences instance = await _prefs;
  instance.setString(KEY_CREDIT, json.encode(credit.toJson()));

}

void saveCateogryList(List<CateogryEntity> categoruList) async {
  SharedPreferences instance = await _prefs;
  instance.setString(KEY_CATEGORY, json.encode(categoruList));

}
Future<List<CateogryEntity>> getCateogryList() async {
  SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_CATEGORY);
  if(stringJson.isEmpty) return null;
  var list= json.decode(stringJson);
  List<CateogryEntity> catList= list
      .map<CateogryEntity>((json) => CateogryEntity.fromJson(json))
      .toList(growable: false);
return catList;

}


void saveCountry(CountryEntity entity) async {
  SharedPreferences instance = await _prefs;
  instance.setString(KEY_COUNTRY, json.encode(entity.toJson()));

}

 Future<CountryEntity> getCountry( ) async {
  SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_LIKED);
  if(stringJson==null) return null;
  return CountryEntity.fromJson(json.decode(stringJson));

}
Future<List<String>> getLikedCommericalList() async {
  SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_LIKED);
  if(stringJson==null) return null;
  List<String> stringList = (jsonDecode(stringJson) as List<dynamic>).cast<String>();
  return stringList;

}
Future<List<String>> getViewedCommericalList() async {
  SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_VIEWD);
  if(stringJson==null) return null;
  List<String> stringList = (jsonDecode(stringJson) as List<dynamic>).cast<String>();
  return stringList;

}

void saveLikedCommericalList(String id) async {
  List<String>ids= List();
    SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_LIKED);
  if(stringJson!=null){
    ids=(jsonDecode(stringJson) as List<dynamic>).cast<String>();
  }
  ids.add(id);
  instance.setString(KEY_LIKED, json.encode(ids));

}



void saveViewCommericalList(String id) async {
  List<String>ids= List();
  SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_VIEWD);
  if(stringJson!=null){
    ids=(jsonDecode(stringJson) as List<dynamic>).cast<String>();
  }
  ids.add(id);
  instance.setString(KEY_VIEWD, json.encode(ids));

}





Future<UserCredit> getUserCredit() async {
  SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_CREDIT);
  return UserCredit.fromJson(json.decode(stringJson));

}

  void setToken(LoginResponse user) async{
    SharedPreferences instance = await _prefs;
    instance.setString(KEY_SESSION, user.accessToken);
    instance.setBool(KEY_IS_LOGGED, true);

  }
Future<String> getToken() async {
  SharedPreferences instance = await _prefs;
 return instance.getString(KEY_SESSION);

}
  void saveCountryID(String countryId)async{
    SharedPreferences instance =await _prefs;
        instance.setString(KEY_COUNTRY_ID, countryId);
  }
Future<String> getCountryID()async{
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

  void saveAllCountry(List<CountryEntity> countryList) async{

    SharedPreferences instance = await _prefs;
    instance.setString(KEY_COUNTRY_LIST, json.encode(countryList));
  }

  Future<List<CountryEntity>> getCountryList() async{
    SharedPreferences instance = await _prefs;
    String stringJson=instance.getString(KEY_COUNTRY_LIST);
    if(stringJson.isEmpty) return null;
    var list= json.decode(stringJson);
    List<CountryEntity> catList= list
        .map<CountryEntity>((json) => CountryEntity.fromJson(json))
        .toList(growable: false);
    return catList;
  }

Future<List<CountryEntity>> getCityList() async{
  SharedPreferences instance = await _prefs;
  String stringJson=instance.getString(KEY_CITY_LIST);
  if(stringJson.isEmpty) return null;
  var list= json.decode(stringJson);
  List<CountryEntity> catList= list
      .map<CountryEntity>((json) => CountryEntity.fromJson(json))
      .toList(growable: false);
  return catList;
}

  Future saveCities(List<CountryEntity> cities)async {

    SharedPreferences instance = await _prefs;
    instance.setString(KEY_CITY_LIST, json.encode(cities));
  }

}