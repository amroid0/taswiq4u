// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_proprtires_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldProprtiresEntity _$FieldProprtiresEntityFromJson(
        Map<String, dynamic> json) =>
    FieldProprtiresEntity(
      CategoryId: json['CategoryId'] as int?,
      Category: json['Category'],
      Required: json['Required'] as bool?,
      SpeceficationId: json['SpeceficationId'] as int?,
      SpecificationOptions: (json['SpecificationOptions'] as List<dynamic>?)
          ?.map((e) => FieldProprtiresSpecificationoption.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      Id: json['Id'] as int?,
      HasRange: json['HasRange'] as bool?,
      MuliSelect: json['MuliSelect'] as bool?,
      CustomValue: json['CustomValue'],
      EnglishName: json['EnglishName'] as String?,
      ArabicName: json['ArabicName'] as String?,
      Value: json['Value'],
      IsCustomValue: json['IsCustomValue'],
    );

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
      'ArabicName': instance.ArabicName,
      'Value': instance.Value,
      'IsCustomValue': instance.IsCustomValue,
    };

FieldProprtiresSpecificationoption _$FieldProprtiresSpecificationoptionFromJson(
        Map<String, dynamic> json) =>
    FieldProprtiresSpecificationoption(
      json['IsSelected'] as bool?,
      json['Id'] as int?,
      json['ArabicName'] as String?,
      json['EnglishName'] as String?,
    );

Map<String, dynamic> _$FieldProprtiresSpecificationoptionToJson(
        FieldProprtiresSpecificationoption instance) =>
    <String, dynamic>{
      'IsSelected': instance.IsSelected,
      'Id': instance.Id,
      'ArabicName': instance.ArabicName,
      'EnglishName': instance.EnglishName,
    };
