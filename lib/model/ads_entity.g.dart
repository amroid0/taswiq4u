// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsEntity _$AdsEntityFromJson(Map<String, dynamic> json) => AdsEntity(
      $id: json[r'$id'] as String?,
      advertisementList: (json['AdvertisementList'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : AdsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      commercialAdsList: (json['CommercialAdsList'] as List<dynamic>?)
          ?.map((e) => CommercialAdsList.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..isLoadMore = json['isLoadMore'] as bool?;

Map<String, dynamic> _$AdsEntityToJson(AdsEntity instance) => <String, dynamic>{
      r'$id': instance.$id,
      'AdvertisementList': instance.advertisementList,
      'CommercialAdsList': instance.commercialAdsList,
      'isLoadMore': instance.isLoadMore,
    };

AdsModel _$AdsModelFromJson(Map<String, dynamic> json) => AdsModel(
      Id: json['Id'] as int?,
      Title: json['Title'] as String?,
      ArabicDescription: json['ArabicDescription'] as String?,
      EnglishDescription: json['EnglishDescription'] as String?,
      IsNogitable: json['IsNogitable'] as bool?,
      Price: (json['Price'] as num?)?.toDouble(),
      CategoryId: json['CategoryId'] as int?,
      CategoryName: json['CategoryName'] as String?,
      UserId: json['UserId'] as String?,
      UserName: json['UserName'] as String?,
      UserPhone: json['UserPhone'] as String?,
      ArabicDescriptionUrl: json['ArabicDescriptionUrl'] as String?,
      EnglishDescriptionUrl: json['EnglishDescriptionUrl'] as String?,
      ArabicTitle: json['ArabicTitle'] as String?,
      EnglishTitle: json['EnglishTitle'] as String?,
      CountryId: json['CountryId'] as int?,
      CountryNameEnglish: json['CountryNameEnglish'] as String?,
      CountryNameArabic: json['CountryNameArabic'] as String?,
      LocationLatitude: (json['LocationLatitude'] as num?)?.toDouble(),
      LocationLongtude: (json['LocationLongtude'] as num?)?.toDouble(),
      IsDisplayed: json['IsDisplayed'] as bool?,
      IsDeleted: json['IsDeleted'] as bool?,
      CreationTime: json['CreationTime'] == null
          ? null
          : DateTime.parse(json['CreationTime'] as String),
      ViewCount: json['ViewCount'] as int?,
      CityId: json['CityId'] as int?,
      CityNameEnglish: json['CityNameEnglish'] as String?,
      CityNameArabic: json['CityNameArabic'] as String?,
      StateId: json['StateId'] as int?,
      StateNameArabic: json['StateNameArabic'] as String?,
      StateNameEnglish: json['StateNameEnglish'] as String?,
      IsFeatured: json['IsFeatured'] as bool?,
      IsFavorite: json['IsFavorite'] as bool?,
      AdvertismentImages: (json['AdvertismentImages'] as List<dynamic>?)
          ?.map((e) => AdvertismentImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdsModelToJson(AdsModel instance) => <String, dynamic>{
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
      'IsFavorite': instance.IsFavorite,
      'AdvertismentImages': instance.AdvertismentImages,
    };

AdvertismentImage _$AdvertismentImageFromJson(Map<String, dynamic> json) =>
    AdvertismentImage(
      json['Id'] as int?,
      json['Url'] as String?,
      (json['Size'] as num?)?.toDouble(),
      json['IsImage'] as bool?,
      json['CreationDate'] == null
          ? null
          : DateTime.parse(json['CreationDate'] as String),
      json['base64Image'] as String?,
    )..isLoading = json['isLoading'] as bool?;

Map<String, dynamic> _$AdvertismentImageToJson(AdvertismentImage instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'Url': instance.Url,
      'Size': instance.Size,
      'IsImage': instance.IsImage,
      'CreationDate': instance.CreationDate?.toIso8601String(),
      'base64Image': instance.base64Image,
      'isLoading': instance.isLoading,
    };

CommercialAdsList _$CommercialAdsListFromJson(Map<String, dynamic> json) =>
    CommercialAdsList(
      json['Id'] as int?,
      json['ImageId'] as int?,
      json['Type'] as int?,
      json['Description'] as String?,
      json['Link'] as String?,
      json['CreationDate'] == null
          ? null
          : DateTime.parse(json['CreationDate'] as String),
      json['EndDate'] == null
          ? null
          : DateTime.parse(json['EndDate'] as String),
      json['Active'] as bool?,
      json['Notification'] as int?,
      json['CountryId'] as int?,
      json['ViewsCount'] as int?,
      json['Likes'] as int?,
      json['CommercialAdsCategoryId'] as int?,
      json['CommercialAdsCategory'] == null
          ? null
          : CommercialAdsCategory.fromJson(
              json['CommercialAdsCategory'] as Map<String, dynamic>),
      json['SystemDataFile'] == null
          ? null
          : SystemDataFile.fromJson(
              json['SystemDataFile'] as Map<String, dynamic>),
      json['base64Image'] as String?,
    )
      ..isLiked = json['isLiked'] as bool?
      ..isViewed = json['isViewed'] as bool?
      ..isLoading = json['isLoading'] as bool?;

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
      'isLiked': instance.isLiked,
      'isViewed': instance.isViewed,
      'CommercialAdsCategoryId': instance.CommercialAdsCategoryId,
      'CommercialAdsCategory': instance.commercialAdsCategory,
      'SystemDataFile': instance.systemDataFile,
      'base64Image': instance.base64Image,
      'isLoading': instance.isLoading,
    };

CommercialAdsCategory _$CommercialAdsCategoryFromJson(
        Map<String, dynamic> json) =>
    CommercialAdsCategory(
      json['NameAr'] as String?,
      json['NameEn'] as String?,
      json['CountryId'] as int?,
      (json['ComercialAds'] as List<dynamic>?)
          ?.map((e) => ComercialAd.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommercialAdsCategoryToJson(
        CommercialAdsCategory instance) =>
    <String, dynamic>{
      'NameAr': instance.NameAr,
      'NameEn': instance.NameEn,
      'CountryId': instance.CountryId,
      'ComercialAds': instance.ComercialAds,
    };

ComercialAd _$ComercialAdFromJson(Map<String, dynamic> json) => ComercialAd();

Map<String, dynamic> _$ComercialAdToJson(ComercialAd instance) =>
    <String, dynamic>{};

SystemDataFile _$SystemDataFileFromJson(Map<String, dynamic> json) =>
    SystemDataFile(
      json['Id'] as int?,
      json['Url'] as String?,
      (json['Size'] as num?)?.toDouble(),
      json['Extention'] as String?,
      json['Type'] as int?,
      json['CreationDate'] == null
          ? null
          : DateTime.parse(json['CreationDate'] as String),
      json['IsDeleted'] as bool?,
      json['IsAssinged'] as bool?,
      (json['ComercialAds'] as List<dynamic>?)
          ?.map((e) => ComercialAd.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

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
      'ComercialAds': instance.ComercialAds,
    };
