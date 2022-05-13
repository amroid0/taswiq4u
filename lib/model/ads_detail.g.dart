// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsDetail _$AdsDetailFromJson(Map<String, dynamic> json) {
  return AdsDetail(
    Id: json['Id'] as int,
    ArabicDescription: json['ArabicDescription'] as String,
    EnglishDescription: json['EnglishDescription'] as String,
    IsNogitable: json['IsNogitable'] as bool,
    Price: (json['Price'] as num)?.toDouble(),
    CategoryId: json['CategoryId'] as int,
    CategoryName: json['CategoryName'] as String,
    UserId: json['UserId'] as String,
    UserName: json['UserName'] as String,
    UserPhone: json['UserPhone'] as String,
    ArabicDescriptionUrl: json['ArabicDescriptionUrl'] as String,
    EnglishDescriptionUrl: json['EnglishDescriptionUrl'] as String,
    TextShareEn: json['TextShareEn'] as String,
    TextShareAr: json['TextShareAr'] as String,
    ArabicTitle: json['ArabicTitle'] as String,
    EnglishTitle: json['EnglishTitle'] as String,
    CountryId: json['CountryId'] as int,
    CountryNameEnglish: json['CountryNameEnglish'] as String,
    CountryNameArabic: json['CountryNameArabic'] as String,
    LocationLatitude: (json['LocationLatitude'] as num)?.toDouble(),
    LocationLongtude: (json['LocationLongtude'] as num)?.toDouble(),
    IsDisplayed: json['IsDisplayed'] as bool,
    IsDeleted: json['IsDeleted'] as bool,
    CreationTime: json['CreationTime'] as String,
    UpdateTime: json['UpdateTime'] as String,
    ViewCount: json['ViewCount'] as int,
    CityId: json['CityId'] as int,
    CityNameEnglish: json['CityNameEnglish'] as String,
    CityNameArabic: json['CityNameArabic'] as String,
    StateId: json['StateId'] as int,
    StateNameArabic: json['StateNameArabic'] as String,
    StateNameEnglish: json['StateNameEnglish'] as String,
    IsFavorite: json['IsFavorite'] as bool,
    IsActive: json['IsActive'] as bool,
    Advertisment_Specification: (json['Advertisment_Specification'] as List)
        ?.map((e) => e == null
            ? null
            : AdvertismentSpecification.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    AdvertismentImages: (json['AdvertismentImages'] as List)
        ?.map((e) => e == null
            ? null
            : AdvertismentImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AdsDetailToJson(AdsDetail instance) => <String, dynamic>{
      'Id': instance.Id,
      'ArabicDescription': instance.ArabicDescription,
      'EnglishDescription': instance.EnglishDescription,
      'IsNogitable': instance.IsNogitable,
      'Price': instance.Price,
      'CategoryId': instance.CategoryId,
      'CategoryName': instance.CategoryName,
      'UserId': instance.UserId,
      'UserName': instance.UserName,
      'UserPhone': instance.UserPhone,
      'ArabicDescriptionUrl': instance.ArabicDescriptionUrl,
      'EnglishDescriptionUrl': instance.EnglishDescriptionUrl,
      'TextShareEn': instance.TextShareEn,
      'TextShareAr': instance.TextShareAr,
      'ArabicTitle': instance.ArabicTitle,
      'EnglishTitle': instance.EnglishTitle,
      'CountryId': instance.CountryId,
      'CountryNameEnglish': instance.CountryNameEnglish,
      'CountryNameArabic': instance.CountryNameArabic,
      'LocationLatitude': instance.LocationLatitude,
      'LocationLongtude': instance.LocationLongtude,
      'IsDisplayed': instance.IsDisplayed,
      'IsDeleted': instance.IsDeleted,
      'CreationTime': instance.CreationTime,
      'UpdateTime': instance.UpdateTime,
      'ViewCount': instance.ViewCount,
      'CityId': instance.CityId,
      'CityNameEnglish': instance.CityNameEnglish,
      'CityNameArabic': instance.CityNameArabic,
      'StateId': instance.StateId,
      'StateNameArabic': instance.StateNameArabic,
      'StateNameEnglish': instance.StateNameEnglish,
      'IsFavorite': instance.IsFavorite,
      'IsActive': instance.IsActive,
      'Advertisment_Specification': instance.Advertisment_Specification,
      'AdvertismentImages': instance.AdvertismentImages,
    };

AdvertismentSpecification _$AdvertismentSpecificationFromJson(
    Map<String, dynamic> json) {
  return AdvertismentSpecification(
    Id: json['Id'] as int,
    CategoryId: json['CategoryId'] as int,
    AdvertismentId: json['AdvertismentId'] as int,
    CategorySpecificationId: json['CategorySpecificationId'] as int,
    NameEnglish: json['NameEnglish'] as String,
    NameArabic: json['NameArabic'] as String,
    CustomValue: json['CustomValue'] as String,
    AdvertismentSpecificatioOptions:
        (json['AdvertismentSpecificatioOptions'] as List)
            ?.map((e) => e == null
                ? null
                : AdsSpecificatioOptions.fromJson(e as Map<String, dynamic>))
            ?.toList(),
    CategorySpecificationVM: json['CategorySpecificationVM'] as String,
    AdvertismentSpecificationOptions:
        json['AdvertismentSpecificationOptions'] as String,
  );
}

Map<String, dynamic> _$AdvertismentSpecificationToJson(
        AdvertismentSpecification instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'CategoryId': instance.CategoryId,
      'AdvertismentId': instance.AdvertismentId,
      'CategorySpecificationId': instance.CategorySpecificationId,
      'NameEnglish': instance.NameEnglish,
      'NameArabic': instance.NameArabic,
      'CustomValue': instance.CustomValue,
      'AdvertismentSpecificatioOptions':
          instance.AdvertismentSpecificatioOptions,
      'CategorySpecificationVM': instance.CategorySpecificationVM,
      'AdvertismentSpecificationOptions':
          instance.AdvertismentSpecificationOptions,
    };

AdsSpecificatioOptions _$AdsSpecificatioOptionsFromJson(
    Map<String, dynamic> json) {
  return AdsSpecificatioOptions(
    Id: json['Id'] as int,
    AdvertismentSpecificationId: json['AdvertismentSpecificationId'] as String,
    NameEnglish: json['NameEnglish'] as String,
    NameArabic: json['NameArabic'] as String,
    SpecificationOptionId: json['SpecificationOptionId'] as int,
  );
}

Map<String, dynamic> _$AdsSpecificatioOptionsToJson(
        AdsSpecificatioOptions instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'AdvertismentSpecificationId': instance.AdvertismentSpecificationId,
      'NameEnglish': instance.NameEnglish,
      'NameArabic': instance.NameArabic,
      'SpecificationOptionId': instance.SpecificationOptionId,
    };
