// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegisterRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return RegisterRequest(
      phone: json['Phone'] as String,
      password: json['Password'] as String,
      confirmPassword: json['ConfirmPassword'] as String,
      countryId: json['CountryId'] as int,
      languageId: json['LanguageId'] as int,
      cityId: json['CityId'] as int);
}

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'Phone': instance.phone,
      'Password': instance.password,
      'ConfirmPassword': instance.confirmPassword,
      'CountryId': instance.countryId,
      'LanguageId': instance.languageId,
      'CityId': instance.cityId
    };
