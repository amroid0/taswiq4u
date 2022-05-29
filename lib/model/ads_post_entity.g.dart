// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_post_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsPostEntity _$AdsPostEntityFromJson(Map<String, dynamic> json) {
  return AdsPostEntity(
    id: json['Id'] as int,
    title: json['Title'] as String,
    arabicDescription: json['ArabicDescription'] as String,
    englishDescription: json['EnglishDescription'] as String,
    price: json['Price'] as int,
    phone: json['Phone'] as String,
    email: json['Email'] as String,
    isNogitable: json['IsNogitable'] as bool,
    categoryId: json['CategoryId'] as int,
    countryId: json['CountryId'] as int,
    cityId: json['CityId'] as int,
    stateId: json['StateId'] as int,
    locationLongtude: json['LocationLongtude'] as int,
    locationLatitude: json['LocationLatitude'] as int,
    userId: json['UserId'] as String,
    isNew: json['IsNew'] as bool,
    contactMe: json['ContactMe'] as int,
    isFree: json['IsFree'] as bool,
    photos: (json['Photos'] as List)
        ?.map((e) =>
            e == null ? null : PhotosBean.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    advertismentSpecification: (json['Advertisment_Specification'] as List)
        ?.map((e) => e == null
            ? null
            : Advertisment_SpecificationBean.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AdsPostEntityToJson(AdsPostEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Id', instance.id);
  val['Title'] = instance.title;
  val['ArabicDescription'] = instance.arabicDescription;
  val['EnglishDescription'] = instance.englishDescription;
  val['Price'] = instance.price;
  val['Phone'] = instance.phone;
  val['Email'] = instance.email;
  val['IsNogitable'] = instance.isNogitable;
  val['CategoryId'] = instance.categoryId;
  val['CountryId'] = instance.countryId;
  val['CityId'] = instance.cityId;
  val['StateId'] = instance.stateId;
  val['LocationLongtude'] = instance.locationLongtude;
  val['LocationLatitude'] = instance.locationLatitude;
  val['UserId'] = instance.userId;
  val['IsNew'] = instance.isNew;
  val['ContactMe'] = instance.contactMe;
  val['IsFree'] = instance.isFree;
  val['Photos'] = instance.photos;
  val['Advertisment_Specification'] = instance.advertismentSpecification;
  return val;
}

Advertisment_SpecificationBean _$Advertisment_SpecificationBeanFromJson(
    Map<String, dynamic> json) {
  return Advertisment_SpecificationBean(
    id: json['Id'] as int,
    customValue: json['CustomValue'] as String,
    advertismentSpecificatioOptions:
        (json['AdvertismentSpecificatioOptions'] as List)
            ?.map((e) => e as int)
            ?.toList(),
  );
}

Map<String, dynamic> _$Advertisment_SpecificationBeanToJson(
        Advertisment_SpecificationBean instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CustomValue': instance.customValue,
      'AdvertismentSpecificatioOptions':
          instance.advertismentSpecificatioOptions,
    };

PhotosBean _$PhotosBeanFromJson(Map<String, dynamic> json) {
  return PhotosBean(
    json['Url'] as String,
    json['Id'] as int,
  );
}

Map<String, dynamic> _$PhotosBeanToJson(PhotosBean instance) =>
    <String, dynamic>{
      'Url': instance.url,
      'Id': instance.id,
    };
