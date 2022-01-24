// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popup_ads_entity_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopupAdsEntityList _$PopupAdsEntityListFromJson(Map<String, dynamic> json) {
  return PopupAdsEntityList(
    json[r'$id'] as String,
    json['Id'] as int,
    json['imageId'] as int,
    json['Type'] as int,
    json['Description'] as String,
    json['Link'] as String,
    json['CreationDate'] as String,
    json['EndDate'] as String,
    json['Active'] as bool,
    json['Notification'] as int,
    json['CountryId'] as int,
    json['ViewsCount'] as int,
    json['Likes'] as int,
    json['CategoryId'] as int,
    json['Category'] == null
        ? null
        : PopupAdsEntityListCategory.fromJson(
            json['Category'] as Map<String, dynamic>),
    json['SystemDataFile'] == null
        ? null
        : PopupAdsEntityListSystemDataFile.fromJson(
            json['SystemDataFile'] as Map<String, dynamic>),
    json['InstagramLink'] as String,
    json['PhoneNumber'] as String,
    json['CommercialAdsUsers'] as List,
  );
}

Map<String, dynamic> _$PopupAdsEntityListToJson(PopupAdsEntityList instance) =>
    <String, dynamic>{
      r'$id': instance.$id,
      'Id': instance.id,
      'imageId': instance.imageId,
      'Type': instance.type,
      'Description': instance.description,
      'Link': instance.link,
      'CreationDate': instance.creationDate,
      'EndDate': instance.endDate,
      'Active': instance.active,
      'Notification': instance.notification,
      'CountryId': instance.countryId,
      'ViewsCount': instance.viewsCount,
      'Likes': instance.likes,
      'CategoryId': instance.categoryId,
      'InstagramLink': instance.instagramLink,
      'PhoneNumber': instance.phoneNumber,
      'Category': instance.category,
      'SystemDataFile1': instance.systemDataFile1,
      'CommercialAdsUsers': instance.commercialAdsUsers,
    };

PopupAdsEntityListCategory _$PopupAdsEntityListCategoryFromJson(
    Map<String, dynamic> json) {
  return PopupAdsEntityListCategory(
    json[r'$id'] as String,
    json['Id'] as int,
    json['Name'] as String,
    json['CategoryLogo'] as String,
  );
}

Map<String, dynamic> _$PopupAdsEntityListCategoryToJson(
        PopupAdsEntityListCategory instance) =>
    <String, dynamic>{
      r'$id': instance.$id,
      'Id': instance.id,
      'Name': instance.name,
      'CategoryLogo': instance.categoryLogo,
    };

PopupAdsEntityListSystemDataFile _$PopupAdsEntityListSystemDataFileFromJson(
    Map<String, dynamic> json) {
  return PopupAdsEntityListSystemDataFile(
    json[r'$id'] as String,
    json['Id'] as int,
    json['Url'] as String,
    (json['Size'] as num)?.toDouble(),
    json['Extention'] as String,
    json['Type'] as int,
    json['CreationDate'] as String,
    json['IsDeleted'] as bool,
    json['IsAssinged'],
  );
}

Map<String, dynamic> _$PopupAdsEntityListSystemDataFileToJson(
        PopupAdsEntityListSystemDataFile instance) =>
    <String, dynamic>{
      r'$id': instance.$id,
      'Id': instance.id,
      'Url': instance.url,
      'Size': instance.size,
      'Extention': instance.extention,
      'Type': instance.type,
      'CreationDate': instance.creationDate,
      'IsDeleted': instance.isDeleted,
      'IsAssinged': instance.isAssinged,
    };
