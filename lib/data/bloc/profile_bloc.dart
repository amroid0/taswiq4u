import 'dart:async';

import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/data/remote/ProfileClient.dart';
import 'package:olx/data/remote/country_client.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/model/password_request_entity.dart';
import 'package:olx/model/userCredit.dart';
import 'package:olx/model/user_info.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:rxdart/rxdart.dart';

import '../registerValidator.dart';
import '../shared_prefs.dart';

class ProfileBloc  extends Bloc with RegisterValidators{

  final _client = ProfileClient();
  final _controller = BehaviorSubject<ApiResponse<UserInfo>>();
  final _phoneController = BehaviorSubject<String>();
  final _firstNameController=BehaviorSubject<String>();
  final _secondNameController=BehaviorSubject<String>();
  final _updatecontroller = BehaviorSubject<ApiResponse<UserInfo>>();
  final _passwordupdatecontroller = BehaviorSubject<ApiResponse<bool>>();

  final _curPasswordController = BehaviorSubject<String>();
  final _newPasswordController=BehaviorSubject<String>();
  final _confrmPasswordController=BehaviorSubject<String>();




  Stream<ApiResponse<UserInfo>> get stream => _controller.stream;
  Stream<ApiResponse<UserInfo>> get updateStream => _updatecontroller.stream;
  Stream<ApiResponse<bool>> get passwordupdateStream => _passwordupdatecontroller.stream;
  Stream<String> get email => _phoneController.stream.transform(validateEmail);
  Stream<String> get firstName => _firstNameController.stream.transform(validateFirstName);
  Stream<String> get seocndName => _secondNameController.stream.transform(validateSeocndName);
  Stream<String> get curpassword => _curPasswordController.stream.transform(validatePassword);
  Stream<String> get newpassword => _newPasswordController.stream.transform(validatePassword);
  Stream<String> get confirmpassword => _confrmPasswordController.stream.transform(validatePassword);

  Stream<bool> get submitValid => CombineLatestStream.combine2(email,firstName, (dynamic e, dynamic p) => true);
  Stream<bool> get updatePasswordValid => CombineLatestStream.combine3(curpassword,newpassword,confirmpassword, (dynamic e, dynamic p,dynamic c) => true);
  Function(String) get changeEmail => _phoneController.sink.add;
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Function(String) get changeSecondName => _secondNameController.sink.add;
  Function(String) get changecurpassword => _curPasswordController.sink.add;
  Function(String) get changenewpassword => _newPasswordController.sink.add;
  Function(String) get changeconfrimpassword => _confrmPasswordController.sink.add;


  final _countryClient = CountryClient();
  final _countryController = BehaviorSubject<ApiResponse<List<CountryEntity>>>();

  Stream<ApiResponse<List<CountryEntity>>> get countryStream => _countryController.stream;

  ProfileBloc();

  void getUserProfileInfo() async {


    Stream.fromFuture(preferences.getUserInfo())
        .onErrorResume((error,stack) => Stream.fromFuture(_client.getUserData()) .doOnData((event) {preferences.saveUserData(event);}))

        .doOnListen(() {        _controller.sink.add(ApiResponse.loading('loading'));
    }).listen((event) {
      _controller.sink.add(ApiResponse.completed(event));


    },onError: (e){
      _controller.sink.add(ApiResponse.error(e.toString()));

    });



    }
  void updateUserProfileInfo()async {

    final validPhone = _phoneController.value;
    final validFirstName = _firstNameController.value.trim();
    List<String>namePattern=validFirstName.split(" ");
   UserInfo currentInfo= await preferences.getUserInfo();
      UserInfo userInfo=new UserInfo();
      userInfo.firstName=namePattern[0];
      userInfo.secondName=namePattern.length<=1?"":namePattern[namePattern.length-1];
      userInfo.phone=validPhone;
      userInfo.email=currentInfo.email;
      userInfo.countryId=userInfo.countryId;
    Stream.fromFuture(_client.updateUserData(userInfo))
        .flatMap((response) => Stream.fromFuture(_client.getUserData()) .doOnData((event) {preferences.saveUserData(event);}))

        .doOnListen(() {        _updatecontroller.sink.add(ApiResponse.loading('loading'));
    }).listen((event) {
      _controller.sink.add(ApiResponse.completed(event));
      _updatecontroller.sink.add(ApiResponse.completed(event));


    },onError: (e){
      _updatecontroller.sink.add(ApiResponse.error(e.toString()));

    });



  }

void getSavedLocalUserInfo()async{
   UserInfo userInfo= await preferences.getUserInfo();
    _updatecontroller.sink.add(ApiResponse.completed(userInfo));
}










  @override
  void dispose() {
    // TODO: implement dispose
  }

  void passordNotMatch() {
    _confrmPasswordController.sink.addError(allTranslations.text("not_match")!);
  }

  updatePassword() async {

    final currntpassword = _curPasswordController.value;
    PasswordRequest request=new PasswordRequest(OldPassword: currntpassword,NewPassword: _newPasswordController.value,ConfirmPassword: _newPasswordController.value);
    UserCredit credit= await preferences.getUserCredit();


    Stream.fromFuture(_client.changePassword(request))
        .doOnData((response) => preferences.saveCredit(new UserCredit(credit.userName, _newPasswordController.value)))

        .doOnListen(() { _passwordupdatecontroller.sink.add(ApiResponse.loading('loading'));
    }).listen((event) {
      _passwordupdatecontroller.sink.add(ApiResponse.completed(true));


    },onError: (e){
      _passwordupdatecontroller.sink.add(ApiResponse.error(e.toString()));

    });



  }


  void getCountryList() async {

    Stream.fromFuture(preferences.getCountryList())
        .onErrorResumeNext(Stream.fromFuture(_countryClient.getCountryList())
        .doOnData((event) {preferences.saveAllCountry(event);}))
        .doOnListen(() {_countryController.sink.add(ApiResponse<List<CountryEntity>>.loading("loading"));
    }).listen((event) {  _countryController.sink.add(ApiResponse<List<CountryEntity>>.completed(event));
    },onError: (e){      _countryController.sink.add(ApiResponse<List<CountryEntity>>.error(e.toString()));
    });


  }



}