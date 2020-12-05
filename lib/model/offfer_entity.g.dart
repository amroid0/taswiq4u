// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offfer_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferEntity _$OfferEntityFromJson(Map<String, dynamic> json) {
  return OfferEntity(
    totalItems: json['TotalItems'] as int,
    page: json['Page'] as int,
    size: json['Size'] as int,
    list: (json['List'] as List)
        ?.map((e) =>
            e == null ? null : OfferDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalPages: json['TotalPages'] as int,
    hasPreviousPage: json['HasPreviousPage'] as bool,
    hasNextPage: json['HasNextPage'] as bool,
    nextPage: json['NextPage'] as int,
    previousPage: json['PreviousPage'] as int,
  );
}

Map<String, dynamic> _$OfferEntityToJson(OfferEntity instance) =>
    <String, dynamic>{
      'TotalItems': instance.totalItems,
      'Page': instance.page,
      'Size': instance.size,
      'List': instance.list,
      'TotalPages': instance.totalPages,
      'HasPreviousPage': instance.hasPreviousPage,
      'HasNextPage': instance.hasNextPage,
      'NextPage': instance.nextPage,
      'PreviousPage': instance.previousPage,
    };

OfferDetail _$OfferDetailFromJson(Map<String, dynamic> json) {
  return OfferDetail(
    id: json['Id'] as int,
    imageId: json['ImageId'] as String,
    type: json['Type'] as int,
    description: json['Description'] as String,
    link: json['Link'] as String,
    creationDate: json['CreationDate'] as String,
    endDate: json['EndDate'] as String,
    active: json['Active'] as bool,
    notification: json['Notification'] as int,
    countryId: json['CountryId'] as int,
    viewsCount: json['ViewsCount'] as int,
    likes: json['Likes'] as int,
    categoryId: json['CategoryId'] as int,
    category: json['Category'] == null
        ? null
        : Category.fromJson(json['Category'] as Map<String, dynamic>),
    systemDataFile: json['SystemDataFile'],
    commercialAdsUsers: json['CommercialAdsUsers'] as List,
    base64Image: json['base64Image'] as String,
  );
}

Map<String, dynamic> _$OfferDetailToJson(OfferDetail instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'ImageId': instance.imageId,
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
      'Category': instance.category,
      'SystemDataFile': instance.systemDataFile,
      'CommercialAdsUsers': instance.commercialAdsUsers,
      'base64Image': instance.base64Image,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['Id'] as int,
    name: json['Name'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
    };
