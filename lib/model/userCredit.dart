

import 'package:json_annotation/json_annotation.dart';

part 'userCredit.g.dart';

@JsonSerializable()
class UserCredit{
  String? userName;
  String? password;

  UserCredit(this.userName, this.password);
  factory UserCredit.fromJson(Map<String, dynamic> json) => _$UserCreditFromJson(json);
  Map<String, dynamic> toJson() => _$UserCreditToJson(this);

}