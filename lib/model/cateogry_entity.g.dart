// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cateogry_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CateogryEntity _$CateogryEntityFromJson(Map<String, dynamic> json) {
  return CateogryEntity(
    countryId: json['CountryId'] as int,
    arabicDescription: json['ArabicDescription'] as String,
    englishDescription: json['EnglishDescription'] as String,
    isActive: json['IsActive'] as bool,
    categoryLevel: json['CategoryLevel'] as int,
    categoryLogo: json['CategoryLogo'] as String,
    imageUrl: json['ImageUrl'] as String,
    id: json['Id'] as int,
    subCats: json['SubCats'] as String,
    subCategories: (json['SubCategories'] as List)
        ?.map((e) => e == null
            ? null
            : CateogryEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    name: json['Name'] as String,
    hasSub: json['HasSub'] as bool,
    isSelected: json['isSelected'] as bool,
  )..imageId = json['imageId'] as String;
}

Map<String, dynamic> _$CateogryEntityToJson(CateogryEntity instance) =>
    <String, dynamic>{
      'CountryId': instance.countryId,
      'ArabicDescription': instance.arabicDescription,
      'EnglishDescription': instance.englishDescription,
      'IsActive': instance.isActive,
      'CategoryLevel': instance.categoryLevel,
      'CategoryLogo': instance.categoryLogo,
      'ImageUrl': instance.imageUrl,
      'imageId': instance.imageId,
      'Id': instance.id,
      'SubCats': instance.subCats,
      'SubCategories': instance.subCategories,
      'Name': instance.name,
      'HasSub': instance.hasSub,
      'isSelected': instance.isSelected,
    };
