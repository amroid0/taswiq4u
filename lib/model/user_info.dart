import 'package:json_annotation/json_annotation.dart';


part 'user_info.g.dart';
@JsonSerializable()
class UserInfo {
  UserInfo({
    this.id,
    this.firstName,
    this.secondName,
    this.email,
    this.phone,
    this.countryId,
    this.countryNameEnglish,
    this.countryNameArabic,
    this.image,
    this.cityId,
    this.cityNameEnglish,
    this.cityNameArabic,
    this.freeAdsCount,
    this.membershipType,
    this.phoneConfirmed,
  });
  @JsonKey(name: "Id")

  String id;
  @JsonKey(name: "FirstName")
  String firstName;
  @JsonKey(name: "SecondName")
  String secondName;
  @JsonKey(name: "Email")
  String email;
  @JsonKey(name: "Phone")
  String phone;
  @JsonKey(name: "CountryId")
  int countryId;
  @JsonKey(name: "CountryNameEnglish")
  String countryNameEnglish;
  @JsonKey(name: "CountryNameArabic")
  String countryNameArabic;
  @JsonKey(name: "Image")
  String image;
  @JsonKey(name: "CityId")
  int cityId;
  @JsonKey(name: "CityNameEnglish")
  String cityNameEnglish;
  @JsonKey(name: "CityNameArabic")
  String cityNameArabic;
  @JsonKey(name: "FreeAdsCount")
  int freeAdsCount;
  @JsonKey(name: "MembershipType")
  bool membershipType;
  @JsonKey(name: "PhoneConfirmed")
  bool phoneConfirmed;

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

}




