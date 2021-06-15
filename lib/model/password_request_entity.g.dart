// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_request_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordRequest _$PasswordRequestFromJson(Map<String, dynamic> json) {
  return PasswordRequest(
    OldPassword: json['OldPassword'] as String,
    NewPassword: json['NewPassword'] as String,
    ConfirmPassword: json['ConfirmPassword'] as String,
  );
}

Map<String, dynamic> _$PasswordRequestToJson(PasswordRequest instance) =>
    <String, dynamic>{
      'OldPassword': instance.OldPassword,
      'NewPassword': instance.NewPassword,
      'ConfirmPassword': instance.ConfirmPassword,
    };
