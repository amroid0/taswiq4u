import 'package:json_annotation/json_annotation.dart';

/// OldPassword : "string"
/// NewPassword : "string"
/// ConfirmPassword : "string"
///
///

part 'password_request_entity.g.dart';

@JsonSerializable()
class PasswordRequest {
  String? OldPassword;
  String? NewPassword;
  String? ConfirmPassword;


  PasswordRequest({this.OldPassword, this.NewPassword, this.ConfirmPassword});

  factory PasswordRequest.fromJson(Map<String, dynamic> map) => _$PasswordRequestFromJson(map);
  Map<String, dynamic> toJson() => _$PasswordRequestToJson(this);

}