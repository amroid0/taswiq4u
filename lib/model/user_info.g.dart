// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['Id'] as String?,
      firstName: json['FirstName'] as String?,
      secondName: json['SecondName'] as String?,
      email: json['Email'] as String?,
      phone: json['Phone'] as String?,
      countryId: json['CountryId'] as int?,
      countryNameEnglish: json['CountryNameEnglish'] as String?,
      countryNameArabic: json['CountryNameArabic'] as String?,
      image: json['Image'] as String?,
      cityId: json['CityId'] as int?,
      cityNameEnglish: json['CityNameEnglish'] as String?,
      cityNameArabic: json['CityNameArabic'] as String?,
      freeAdsCount: json['FreeAdsCount'] as int?,
      membershipType: json['MembershipType'] as bool?,
      phoneConfirmed: json['PhoneConfirmed'] as bool?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'Id': instance.id,
      'FirstName': instance.firstName,
      'SecondName': instance.secondName,
      'Email': instance.email,
      'Phone': instance.phone,
      'CountryId': instance.countryId,
      'CountryNameEnglish': instance.countryNameEnglish,
      'CountryNameArabic': instance.countryNameArabic,
      'Image': instance.image,
      'CityId': instance.cityId,
      'CityNameEnglish': instance.cityNameEnglish,
      'CityNameArabic': instance.cityNameArabic,
      'FreeAdsCount': instance.freeAdsCount,
      'MembershipType': instance.membershipType,
      'PhoneConfirmed': instance.phoneConfirmed,
    };
