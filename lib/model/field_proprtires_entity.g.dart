// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_proprtires_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldProprtiresEntity _$FieldProprtiresEntityFromJson(
    Map<String, dynamic> json) {
  return FieldProprtiresEntity(
      json['CategoryId'] as int,
      json['Category'],
      json['Required'] as bool,
      json['SpeceficationId'] as int,
      (json['SpecificationOptions'] as List)
          ?.map((e) => e == null
              ? null
              : FieldProprtiresSpecificationoption.fromJson(
                  e as Map<String, dynamic>))
          ?.toList(),
      json['Id'] as int,
      json['HasRange'] as bool,
      json['MuliSelect'] as bool,
      json['CustomValue'],
      json['EnglishName'] as String,
      json['ArabicName'] as String);
}

Map<String, dynamic> _$FieldProprtiresEntityToJson(
        FieldProprtiresEntity instance) =>
    <String, dynamic>{
      'CategoryId': instance.CategoryId,
      'Category': instance.Category,
      'Required': instance.Required,
      'SpeceficationId': instance.SpeceficationId,
      'SpecificationOptions': instance.SpecificationOptions,
      'Id': instance.Id,
      'HasRange': instance.HasRange,
      'MuliSelect': instance.MuliSelect,
      'CustomValue': instance.CustomValue,
      'EnglishName': instance.EnglishName,
      'ArabicName': instance.ArabicName
    };

FieldProprtiresSpecificationoption _$FieldProprtiresSpecificationoptionFromJson(
    Map<String, dynamic> json) {
  return FieldProprtiresSpecificationoption(
      json['IsSelected'] as bool,
      json['Id'] as int,
      json['ArabicName'] as String,
      json['EnglishName'] as String);
}

Map<String, dynamic> _$FieldProprtiresSpecificationoptionToJson(
        FieldProprtiresSpecificationoption instance) =>
    <String, dynamic>{
      'IsSelected': instance.IsSelected,
      'Id': instance.Id,
      'ArabicName': instance.ArabicName,
      'EnglishName': instance.EnglishName
    };
