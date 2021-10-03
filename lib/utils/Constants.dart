/*
 * Copyright 2018 Harsh Sharma
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import 'package:olx/data/shared_prefs.dart';
import 'package:olx/utils/global_locale.dart';

///////////////////////////////////////////////////////////////////////////////
class APIConstants {
  static const String API_BASE_ENDPOINT = "http://api.taswiq4u.com/";
  static const String OCTET_STREAM_ENCODING = "application/json";
  static const String LOGIN= "${API_BASE_ENDPOINT}api/token";
  static const String REGISTER_BASE_URL = '${API_BASE_ENDPOINT}api/Auth/Register';
  static const String FIELDS_ADD_ADS="${API_BASE_ENDPOINT}api/Ads/AddAdvertismentForm/";
  static const String ADD_ADS="${API_BASE_ENDPOINT}api/Ads/AddNewAdvertisment";
  static const String CATEOGRY_ADS="${API_BASE_ENDPOINT}api/category/MainCategoriesNew";
 static const String COMM_CATEOGRY_ADS= "${API_BASE_ENDPOINT}api/CommercialAdCategory/GetAllCountryCategory";
  static const String SEARCH_WITH_PARAM="${API_BASE_ENDPOINT}api/Ads/SearchWithParams";
  static const String IMAGE_UPLOAD="${API_BASE_ENDPOINT}Api/ImageUpload/AddAdvertismentImage";
  static const String SLIDER_ADS="${API_BASE_ENDPOINT}api/CommercialAd/GetMainSliderAds/";
  static const String FILTER_FIELDS_API="${API_BASE_ENDPOINT}api/Ads/SearchAdsForm/";
  static const String EDIT_FIELD="${API_BASE_ENDPOINT}api/Ads/EditAdvertismentForm/";
  static const String DETAIL_API="${API_BASE_ENDPOINT}api/Ads/AdDetails";
  static const String EDIT_ADS="${API_BASE_ENDPOINT}api/Ads/EditAdvertisment";
  static const String SEARCH_KEY="${API_BASE_ENDPOINT}api/Ads/SearchWithKeys";
  static const String OFFER_ADS="${API_BASE_ENDPOINT}api/CommercialAd/GetOfferAds/";
  static const String FAVROITE_ADS="${API_BASE_ENDPOINT}Api/Favorite/GetFavoriteAds";
   static const String GET_IMAGE="${API_BASE_ENDPOINT}Api/ImageUpload/GetAdImage";
  static const String GET_COMMERCIAL_ADD="${API_BASE_ENDPOINT}api/CommercialAd/ViewAd/";
  static const String VIEW_ADS_API="${API_BASE_ENDPOINT}api/CommercialAd/ViewAd/";
  static const String LIKE_ADS_API="${API_BASE_ENDPOINT}api/CommercialAd/LikeAd/";
  static const String CHECK_VERIFY="${API_BASE_ENDPOINT}api/Auth/isVerified";

  static const String VERFIY_PHONE_API="${API_BASE_ENDPOINT}api/Auth/Verify";

  static const String POPUP_ADS="${API_BASE_ENDPOINT}api/CommercialAd/GetPopUpAds/";

  static const String MAIN_SLIDER_ADS="${API_BASE_ENDPOINT}api/CommercialAd/GetMainSliderAds/";
  static const ADD_FAVROITE="${API_BASE_ENDPOINT}Api/Favorite/AddToFavorite";
  static const UNFAROITE="${API_BASE_ENDPOINT}Api/Favorite/RemoveFromFavorite";

  static const String MY_ADS="${API_BASE_ENDPOINT}api/Ads/GetMyAds";

  static const String USER_PROFILE_API="${API_BASE_ENDPOINT}api/Auth/GetUserFullData";

  static const String COUNTRY_API="${API_BASE_ENDPOINT}api/country/CountriesList";

  static final String CITY_API="${API_BASE_ENDPOINT}api/country/GetActiveCities";

  static final String FIELDS_EDIT_ADS="${API_BASE_ENDPOINT}api/Ads/EditAdvertismentForm/";

  static final String USER_UPDATE_API="${API_BASE_ENDPOINT}api/Auth/UpdateUserData";

  static final String PASSWORD_UPDATE_API="${API_BASE_ENDPOINT}api/Auth/ChangePassword";

  static final String FORGET_PASS_API="${API_BASE_ENDPOINT}api/Auth/ForgetPassword";

  static final String RESET_PASS_API="${API_BASE_ENDPOINT}api/Auth/SetPassword";

  static final String Repoert_Ads_API="${API_BASE_ENDPOINT}/api/Ads/AddAbuseReport";

  static String getFullImageUrl(String url,int type){
    return  url!=null&&url.isNotEmpty?'http://api.taswiq4u.com/Api/ImageUpload/i?url=$url&type=$type':"";

  }

  static Future<String> getPolicyUrl()async{
    return  "http://beta.taswiq4u.com/Privacy?appcountryid=${await preferences.getCountryID()}&applangid=${allTranslations.isEnglish?"en":"ar"}#step-1";
  }
  static Future<String> getRuleUrl()async{
    return  "http://beta.taswiq4u.com/TermsOfUse?appcountryid=${await preferences.getCountryID()}&applangid=${allTranslations.isEnglish?"en":"ar"}#step-1";
  }
  static Future<String> getContactUrl()async{
    return  "http://beta.taswiq4u.com/ContactUs?appcountryid=${await preferences.getCountryID()}&applangid=${allTranslations.isEnglish?"en":"ar"}#step-1";
  }
  static Future<String> getAboutUsUrl()async{
    return  "http://beta.taswiq4u.com/aboutus/?appcountryid=1&applangid=ar#step-1";
  }
  static Future<String> getFAQUsUrl()async{
    return  "http://beta.taswiq4u.com/FAQ#s1";

  }

}

class ImageType {
  static const int COMMAD=1;
  static const int ADS= 2;
  static const int CATE= 3;
  static const int COUNTRY= 4;
}

///////////////////////////////////////////////////////////////////////////////
class APIOperations {
  static const String LOGIN = "login";
  static const String REGISTER = "register";
  static const String CHANGE_PASSWORD = "chgPass";
  static const String SUCCESS = "success";
  static const String FAILURE = "failure";
}

///////////////////////////////////////////////////////////////////////////////
class EventConstants {
  static const int NO_INTERNET_CONNECTION = 0;

///////////////////////////////////////////////////////////////////////////////
  static const int LOGIN_USER_SUCCESSFUL = 500;
  static const int LOGIN_USER_UN_SUCCESSFUL = 501;

///////////////////////////////////////////////////////////////////////////////
  static const int USER_REGISTRATION_SUCCESSFUL = 502;
  static const int USER_REGISTRATION_UN_SUCCESSFUL = 503;
  static const int USER_ALREADY_REGISTERED = 504;

///////////////////////////////////////////////////////////////////////////////
  static const int CHANGE_PASSWORD_SUCCESSFUL = 505;
  static const int CHANGE_PASSWORD_UN_SUCCESSFUL = 506;
  static const int INVALID_OLD_PASSWORD = 507;
///////////////////////////////////////////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////
class APIResponseCode {
  static const int SC_OK = 200;
}
///////////////////////////////////////////////////////////////////////////////

class SharedPreferenceKeys {
  static const String IS_USER_LOGGED_IN = "IS_USER_LOGGED_IN";
  static const String USER = "USER";
}

///////////////////////////////////////////////////////////////////////////////
class ProgressDialogTitles {
  static const String IN_PROGRESS = "In Progress...";
  static const String USER_LOG_IN = "Logging In...";
  static const String USER_CHANGE_PASSWORD = "Changing...";
  static const String USER_REGISTER = "Registering...";
}

///////////////////////////////////////////////////////////////////////////////
class SnackBarText {
  static const String NO_INTERNET_CONNECTION = "No Internet Conenction";
  static const String LOGIN_SUCCESSFUL = "Login Successful";
  static const String LOGIN_UN_SUCCESSFUL = "Login Un Successful";
  static const String CHANGE_PASSWORD_SUCCESSFUL = "Change Password Successful";
  static const String CHANGE_PASSWORD_UN_SUCCESSFUL =
      "Change Password Un Successful";
  static const String REGISTER_SUCCESSFUL = "Register Successful";
  static const String REGISTER_UN_SUCCESSFUL = "Register Un Successful";
  static const String USER_ALREADY_REGISTERED = "User Already Registered";
  static const String ENTER_PASS = "Please Enter your Password";
  static const String ENTER_NEW_PASS = "Please Enter your New Password";
  static const String ENTER_OLD_PASS = "Please Enter your Old Password";
  static const String ENTER_EMAIL = "Please Enter your Email Id";
  static const String ENTER_VALID_MAIL = "Please Enter Valid Email Id";
  static const String ENTER_NAME = "Please Enter your Name";
  static const String INVALID_OLD_PASSWORD = "Invalid Old Password";
}

///////////////////////////////////////////////////////////////////////////////
class Texts {
  static const String REGISTER_NOW = "Not Registered ? Register Now !";
  static const String LOGIN_NOW = "Already Registered ? Login Now !";
  static const String LOGIN = "LOGIN";
  static const String REGISTER = "REGISTER";
  static const String PASSWORD = "Password";
  static const String OLD_PASSWORD = "Old Password";
  static const String NEW_PASSWORD = "New Password";
  static const String CHANGE_PASSWORD = "CHANGE PASSWORD";
  static const String LOGOUT = "LOGOUT";
  static const String EMAIL = "Email";
  static const String NAME = "Name";
}
///////////////////////////////////////////////////////////////////////////////
