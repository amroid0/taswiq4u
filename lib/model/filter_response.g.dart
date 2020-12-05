// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterParamsEntity _$FilterParamsEntityFromJson(Map<String, dynamic> json) {
  return FilterParamsEntity(
    priceMin: (json['priceMin'] as num)?.toDouble(),
    priceMax: (json['priceMax'] as num)?.toDouble(),
    isNew: json['isNew'] as bool,
    countryId: json['countryId'] as int,
    cityId: json['cityId'] as int,
    stateId: json['stateId'] as int,
    categoryId: json['categoryId'] as int,
    key: json['key'] as String,
    params: (json['params'] as List)
        ?.map((e) =>
            e == null ? null : Params.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FilterParamsEntityToJson(FilterParamsEntity instance) =>
    <String, dynamic>{
      'priceMin': instance.priceMin,
      'priceMax': instance.priceMax,
      'isNew': instance.isNew,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'stateId': instance.stateId,
      'categoryId': instance.categoryId,
      'key': instance.key,
      'params': instance.params,
    };

Params _$ParamsFromJson(Map<String, dynamic> json) {
  return Params(
    specificationId: json['specificationId'] as int,
    options: (json['options'] as List)?.map((e) => e as int)?.toList(),
    hasOptions: json['hasOptions'] as bool,
    value: json['value'] as String,
    hasRange: json['hasRange'] as bool,
    min: json['min'] as int,
    max: json['max'] as int,
  );
}

Map<String, dynamic> _$ParamsToJson(Params instance) => <String, dynamic>{
      'specificationId': instance.specificationId,
      'options': instance.options,
      'hasOptions': instance.hasOptions,
      'value': instance.value,
      'hasRange': instance.hasRange,
      'min': instance.min,
      'max': instance.max,
    };
