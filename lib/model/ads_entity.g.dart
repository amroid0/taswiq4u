// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsEntity _$AdsEntityFromJson(Map<String, dynamic> json) {
  return AdsEntity(
      advertisementList: json['AdvertisementList'] == null
          ? null
          : AdvertisementList.fromJson(
              json['AdvertisementList'] as Map<String, dynamic>),
      commercialAdsList: (json['CommercialAdsList'] as List)
          ?.map((e) => e == null
              ? null
              : CommercialAdsList.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$AdsEntityToJson(AdsEntity instance) => <String, dynamic>{
      'AdvertisementList': instance.advertisementList,
      'CommercialAdsList': instance.commercialAdsList
    };

AdvertisementList _$AdvertisementListFromJson(Map<String, dynamic> json) {
  return AdvertisementList(
      totalItems: json['TotalItems'] as int,
      page: json['Page'] as int,
      size: json['Size'] as int,
      list: (json['List'] as List)
          ?.map((e) => e == null
              ? null
              : ListElement.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      totalPages: json['TotalPages'] as int,
      hasPreviousPage: json['HasPreviousPage'] as bool,
      hasNextPage: json['HasNextPage'] as bool,
      nextPage: json['NextPage'] as int,
      previousPage: json['PreviousPage'] as int);
}

Map<String, dynamic> _$AdvertisementListToJson(AdvertisementList instance) =>
    <String, dynamic>{
      'TotalItems': instance.totalItems,
      'Page': instance.page,
      'Size': instance.size,
      'List': instance.list,
      'TotalPages': instance.totalPages,
      'HasPreviousPage': instance.hasPreviousPage,
      'HasNextPage': instance.hasNextPage,
      'NextPage': instance.nextPage,
      'PreviousPage': instance.previousPage
    };

ListElement _$ListElementFromJson(Map<String, dynamic> json) {
  return ListElement(
      json['Id'] as int,
      json['Title'] as String,
      json['ArabicDescription'] as String,
      json['EnglishDescription'] as String,
      json['IsNogitable'] as bool,
      (json['Price'] as num)?.toDouble(),
      json['CategoryId'] as int,
      json['CategoryName'] as String,
      json['UserId'] as String,
      json['UserName'] as String,
      json['UserPhone'] as String,
      json['ArabicDescriptionUrl'] as String,
      json['EnglishDescriptionUrl'] as String,
      json['ArabicTitle'] as String,
      json['EnglishTitle'] as String,
      json['CountryId'] as int,
      json['CountryNameEnglish'] as String,
      json['CountryNameArabic'] as String,
      (json['LocationLatitude'] as num)?.toDouble(),
      (json['LocationLongtude'] as num)?.toDouble(),
      json['IsDisplayed'] as bool,
      json['IsDeleted'] as bool,
      json['CreationTime'] == null
          ? null
          : DateTime.parse(json['CreationTime'] as String),
      json['ViewCount'] as int,
      json['CityId'] as int,
      json['CityNameEnglish'] as String,
      json['CityNameArabic'] as String,
      json['StateId'] as int,
      json['StateNameArabic'] as String,
      json['StateNameEnglish'] as String,
      json['IsFeatured'] as bool,
      (json['AdvertismentImages'] as List)
          ?.map((e) => e == null
              ? null
              : AdvertismentImage.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ListElementToJson(ListElement instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'Title': instance.Title,
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
      'ArabicTitle': instance.ArabicTitle,
      'EnglishTitle': instance.EnglishTitle,
      'CountryId': instance.CountryId,
      'CountryNameEnglish': instance.CountryNameEnglish,
      'CountryNameArabic': instance.CountryNameArabic,
      'LocationLatitude': instance.LocationLatitude,
      'LocationLongtude': instance.LocationLongtude,
      'IsDisplayed': instance.IsDisplayed,
      'IsDeleted': instance.IsDeleted,
      'CreationTime': instance.CreationTime?.toIso8601String(),
      'ViewCount': instance.ViewCount,
      'CityId': instance.CityId,
      'CityNameEnglish': instance.CityNameEnglish,
      'CityNameArabic': instance.CityNameArabic,
      'StateId': instance.StateId,
      'StateNameArabic': instance.StateNameArabic,
      'StateNameEnglish': instance.StateNameEnglish,
      'IsFeatured': instance.IsFeatured,
      'AdvertismentImages': instance.AdvertismentImages
    };

AdvertismentImage _$AdvertismentImageFromJson(Map<String, dynamic> json) {
  return AdvertismentImage(
      json['Id'] as int,
      json['Url'] as String,
      json['Size'] as int,
      json['IsImage'] as bool,
      json['CreationDate'] == null
          ? null
          : DateTime.parse(json['CreationDate'] as String));
}

Map<String, dynamic> _$AdvertismentImageToJson(AdvertismentImage instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'Url': instance.Url,
      'Size': instance.Size,
      'IsImage': instance.IsImage,
      'CreationDate': instance.CreationDate?.toIso8601String()
    };

CommercialAdsList _$CommercialAdsListFromJson(Map<String, dynamic> json) {
  return CommercialAdsList(
      json['Id'] as int,
      json['ImageId'] as int,
      json['Type'] as int,
      json['Description'] as String,
      json['Link'] as String,
      json['CreationDate'] == null
          ? null
          : DateTime.parse(json['CreationDate'] as String),
      json['EndDate'] == null
          ? null
          : DateTime.parse(json['EndDate'] as String),
      json['Active'] as bool,
      json['Notification'] as int,
      json['CountryId'] as int,
      json['ViewsCount'] as int,
      json['Likes'] as int,
      json['CommercialAdsCategoryId'] as int,
      json['CommercialAdsCategory'] == null
          ? null
          : CommercialAdsCategory.fromJson(
              json['CommercialAdsCategory'] as Map<String, dynamic>),
      json['SystemDataFile'] == null
          ? null
          : SystemDataFile.fromJson(
              json['SystemDataFile'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CommercialAdsListToJson(CommercialAdsList instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'ImageId': instance.ImageId,
      'Type': instance.Type,
      'Description': instance.Description,
      'Link': instance.Link,
      'CreationDate': instance.CreationDate?.toIso8601String(),
      'EndDate': instance.EndDate?.toIso8601String(),
      'Active': instance.Active,
      'Notification': instance.Notification,
      'CountryId': instance.CountryId,
      'ViewsCount': instance.ViewsCount,
      'Likes': instance.Likes,
      'CommercialAdsCategoryId': instance.CommercialAdsCategoryId,
      'CommercialAdsCategory': instance.commercialAdsCategory,
      'SystemDataFile': instance.systemDataFile
    };

CommercialAdsCategory _$CommercialAdsCategoryFromJson(
    Map<String, dynamic> json) {
  return CommercialAdsCategory(
      json['NameAr'] as String,
      json['NameEn'] as String,
      json['CountryId'] as int,
      (json['ComercialAds'] as List)
          ?.map((e) => e == null
              ? null
              : ComercialAd.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CommercialAdsCategoryToJson(
        CommercialAdsCategory instance) =>
    <String, dynamic>{
      'NameAr': instance.NameAr,
      'NameEn': instance.NameEn,
      'CountryId': instance.CountryId,
      'ComercialAds': instance.ComercialAds
    };

ComercialAd _$ComercialAdFromJson(Map<String, dynamic> json) {
  return ComercialAd();
}

Map<String, dynamic> _$ComercialAdToJson(ComercialAd instance) =>
    <String, dynamic>{};

SystemDataFile _$SystemDataFileFromJson(Map<String, dynamic> json) {
  return SystemDataFile(
      json['Id'] as int,
      json['Url'] as String,
      json['Size'] as int,
      json['Extention'] as String,
      json['Type'] as int,
      json['CreationDate'] == null
          ? null
          : DateTime.parse(json['CreationDate'] as String),
      json['IsDeleted'] as bool,
      json['IsAssinged'] as bool,
      (json['ComercialAds'] as List)
          ?.map((e) => e == null
              ? null
              : ComercialAd.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SystemDataFileToJson(SystemDataFile instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'Url': instance.Url,
      'Size': instance.Size,
      'Extention': instance.Extention,
      'Type': instance.Type,
      'CreationDate': instance.CreationDate?.toIso8601String(),
      'IsDeleted': instance.IsDeleted,
      'IsAssinged': instance.IsAssinged,
      'ComercialAds': instance.ComercialAds
    };
