// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryEntity _$CountryEntityFromJson(Map<String, dynamic> json) =>
    CountryEntity(
      id: json['Id'] as int?,
      countryId: json['CountryId'] as int?,
      arabicDescription: json['ArabicDescription'] as String?,
      englishDescription: json['EnglishDescription'] as String?,
      name: json['Name'] as String?,
      flag: json['Flag'] as String?,
      featuredAdCost: (json['FeaturedAdCost'] as num?)?.toDouble(),
      freeAdCount: json['FreeAdCount'] as int?,
      phoneKey: json['PhoneKey'] as String?,
      imageId: json['imageId'] as int?,
      currency: json['Currency'] == null
          ? null
          : Currency.fromJson(json['Currency'] as Map<String, dynamic>),
      language: json['Language'] == null
          ? null
          : Language.fromJson(json['Language'] as Map<String, dynamic>),
      abbr: json['Abbr'] as String?,
      categories: (json['Categories'] as List<dynamic>?)
          ?.map((e) => CateogryEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountryEntityToJson(CountryEntity instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CountryId': instance.countryId,
      'ArabicDescription': instance.arabicDescription,
      'EnglishDescription': instance.englishDescription,
      'Name': instance.name,
      'Flag': instance.flag,
      'FeaturedAdCost': instance.featuredAdCost,
      'FreeAdCount': instance.freeAdCount,
      'PhoneKey': instance.phoneKey,
      'imageId': instance.imageId,
      'Currency': instance.currency,
      'Language': instance.language,
      'Abbr': instance.abbr,
      'Categories': instance.categories,
    };

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      id: json['Id'] as int?,
      name: json['Name'] as String?,
      abbr: json['Abbr'] as String?,
    );

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Abbr': instance.abbr,
    };

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      id: json['Id'] as int?,
      name: json['Name'] as String?,
      active: json['Active'] as bool?,
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Active': instance.active,
    };
