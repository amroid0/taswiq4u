// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    json['access_token'] as String,
    json['token_type'] as String,
    json['expires_in'] as int,
    json['userName'] as String,
    json['.issued'] as String,
    json['.expires'] as String,
    json['error'] as String,
    json['error_description'] as String,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'userName': instance.userName,
      '.issued': instance.issued,
      '.expires': instance.expires,
      'error': instance.error,
      'error_description': instance.errorDescription,
    };
