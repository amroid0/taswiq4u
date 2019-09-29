

import 'package:json_annotation/json_annotation.dart';
part 'RegisterRequest.g.dart';

@JsonSerializable()
class RegisterRequest{
@JsonKey(name: "Phone")
String phone;
@JsonKey(name: "Password")
String password;
@JsonKey(name: "ConfirmPassword")
String confirmPassword;
@JsonKey(name: "CountryId")
int countryId;
@JsonKey(name: "LanguageId")
int languageId;
@JsonKey(name: "CityId")
int cityId;

RegisterRequest(
    {this.phone,
      this.password,
      this.confirmPassword,
      this.countryId,
      this.languageId,
      this.cityId});

factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
    _$RegisterRequestFromJson(json);


Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

}