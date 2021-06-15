// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_field_property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditFieldProperty _$EditFieldPropertyFromJson(Map<String, dynamic> json) {
  return EditFieldProperty(
    $id: json[r'$id'] as String,
    AdData: json['AdData'] == null
        ? null
        : AdsDetail.fromJson(json['AdData'] as Map<String, dynamic>),
    CategorySpecification: (json['CategorySpecification'] as List)
        ?.map((e) => e == null
            ? null
            : FieldProprtiresEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EditFieldPropertyToJson(EditFieldProperty instance) =>
    <String, dynamic>{
      r'$id': instance.$id,
      'AdData': instance.AdData,
      'CategorySpecification': instance.CategorySpecification,
    };
