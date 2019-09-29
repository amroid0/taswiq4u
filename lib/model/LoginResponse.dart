import 'package:json_annotation/json_annotation.dart';

part 'LoginResponse.g.dart';
@JsonSerializable()

class LoginResponse {
   @JsonKey(name:"access_token")
  String accessToken;
   @JsonKey(name:"token_type")

   String tokenType;
   @JsonKey(name:"expires_in")
   int expiresIn;
  String userName;
   @JsonKey(name:".issued")
   String issued;
   @JsonKey(name:".expires")
   String expires;
   @JsonKey(name:"error")
   String error;
   @JsonKey(name:"error_description")
   String errorDescription;


  LoginResponse(this.accessToken, this.tokenType, this.expiresIn,
      this.userName, this.issued, this.expires, this.error,
      this.errorDescription);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}