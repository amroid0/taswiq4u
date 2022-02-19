// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cityModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityModel _$CityModelFromJson(Map<String, dynamic> json) => CityModel(
      id: json['Id'] as int?,
      countryId: json['CountryId'] as int?,
      arabicDescription: json['ArabicName'] as String?,
      englishDescription: json['EnglishName'] as String?,
      name: json['Name'] as String?,
      flag: json['Flag'] as String?,
    );

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
      'Id': instance.id,
      'CountryId': instance.countryId,
      'ArabicName': instance.arabicDescription,
      'EnglishName': instance.englishDescription,
      'Name': instance.name,
      'Flag': instance.flag,
    };
