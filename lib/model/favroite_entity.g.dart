// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favroite_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      json['Totalitems'] as int?,
      json['Page'] as int?,
      json['Size'] as int?,
      (json['List'] as List<dynamic>?)
          ?.map((e) => AdsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['TotalPages'] as int?,
      json['HasPreviousPage'] as bool?,
      json['HasNextPage'] as bool?,
      json['NextPage'] as int?,
      json['PreviousPage'] as int?,
    )..isLoadMore = json['isLoadMore'];

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'Totalitems': instance.Totalitems,
      'Page': instance.Page,
      'Size': instance.Size,
      'List': instance.list,
      'TotalPages': instance.TotalPages,
      'HasPreviousPage': instance.HasPreviousPage,
      'HasNextPage': instance.HasNextPage,
      'NextPage': instance.NextPage,
      'PreviousPage': instance.PreviousPage,
      'isLoadMore': instance.isLoadMore,
    };

FavAds _$FavAdsFromJson(Map<String, dynamic> json) => FavAds(
      json['Id'] as int?,
      json['Title'] as String?,
      json['ArabicDescription'] as String?,
      json['EnglishDescription'] as String?,
      json['IsNogitable'] as bool?,
      (json['Price'] as num?)?.toDouble(),
      json['CategoryId'] as int?,
      json['CategoryName'] as String?,
      json['UserId'] as String?,
      json['UserName'] as String?,
      json['UserPhone'] as String?,
      json['ArabicDescriptionUrl'] as String?,
      json['EnglishDescriptionUrl'] as String?,
      json['ArabicTitle'] as String?,
      json['EnglishTitle'] as String?,
      json['CountryId'] as int?,
      json['CountryNameEnglish'] as String?,
      json['CountryNameArabic'] as String?,
      (json['LocationLatitude'] as num?)?.toDouble(),
      (json['LocationLongtude'] as num?)?.toDouble(),
      json['IsDisplayed'] as bool?,
      json['IsDeleted'] as bool?,
      json['CreationTime'] == null
          ? null
          : DateTime.parse(json['CreationTime'] as String),
      json['ViewCount'] as int?,
      json['CityId'] as int?,
      json['CityNameEnglish'] as String?,
      json['CityNameArabic'] as String?,
      json['StateId'] as int?,
      json['StateNameArabic'] as String?,
      json['StateNameEnglish'] as String?,
      json['IsFeatured'] as bool?,
      json['IsFavorite'] as bool?,
      (json['AdvertismentImages'] as List<dynamic>?)
          ?.map((e) => AdvertismentImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavAdsToJson(FavAds instance) => <String, dynamic>{
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
