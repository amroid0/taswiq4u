
import 'package:json_annotation/json_annotation.dart';
part 'ads_post_entity.g.dart';

/// Id : 0
/// Title : "string"
/// ArabicDescription : "string"
/// EnglishDescription : "string"
/// Price : 0
/// Phone : "string"
/// Email : "string"
/// IsNogitable : true
/// CategoryId : 0
/// CountryId : 0
/// CityId : 0
/// StateId : 0
/// LocationLongtude : 0
/// LocationLatitude : 0
/// UserId : "string"
/// IsNew : true
/// ContactMe : 1
/// Photos : [{"Url":"string","Id":0}]
/// Advertisment_Specification : [{"Id":0,"AdvertismentSpecificatioOptions":[0]}]
@JsonSerializable()
class AdsPostEntity {
  /*int Id;
  String Title;
  String ArabicDescription;
  String EnglishDescription;
  int Price;
  String Phone;
  String Email;
  bool IsNogitable;
  int CategoryId;
  int CountryId;
  int CityId;
  int StateId;
  int LocationLongtude;
  int LocationLatitude;
  String UserId;
  bool IsNew;
  int ContactMe;
  List<PhotosBean> Photos;
  List<Advertisment_SpecificationBean> AdvertismentSpecification;
  */
  @JsonKey(name: "Id",includeIfNull: false)
  int? id;
  @JsonKey(name: "Title")
  String? title;
  @JsonKey(name: "ArabicDescription")
  String? arabicDescription;
  @JsonKey(name: "EnglishDescription")
  String? englishDescription;
  @JsonKey(name: "Price")
  int? price;
  @JsonKey(name: "Phone")
  String? phone;
  @JsonKey(name: "Email")
  String? email;
  @JsonKey(name: "IsNogitable")
  bool? isNogitable;
  @JsonKey(name: "CategoryId")
  int? categoryId;
  @JsonKey(name: "CountryId")
  int? countryId;
  @JsonKey(name: "CityId")
  int? cityId;
  @JsonKey(name: "StateId")
  int? stateId;
  @JsonKey(name: "LocationLongtude")
  int? locationLongtude;
  @JsonKey(name: "LocationLatitude")
  int? locationLatitude;
  @JsonKey(name: "UserId")
  String? userId;
  @JsonKey(name: "IsNew")
  bool? isNew;
  @JsonKey(name: "ContactMe")
  int? contactMe;
  @JsonKey(name: "IsFree")
  bool? isFree;
  @JsonKey(name: "Photos")
  List<PhotosBean>? photos;
  @JsonKey(name: "AdvertismentSpecification")
  List<Advertisment_SpecificationBean?>? advertismentSpecification;

  AdsPostEntity({
      this.id,
      this.title,
      this.arabicDescription,
      this.englishDescription,
      this.price,
      this.phone,
      this.email,
      this.isNogitable,
      this.categoryId,
      this.countryId,
      this.cityId,
      this.stateId,
      this.locationLongtude,
      this.locationLatitude,
      this.userId,
      this.isNew,
      this.contactMe,
      this.isFree,
      this.photos,
      this.advertismentSpecification});

  factory AdsPostEntity.fromJson(Map<String, dynamic> json) => _$AdsPostEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AdsPostEntityToJson(this);


}

/// Id : 0
/// AdvertismentSpecificatioOptions : [0]
@JsonSerializable()

class Advertisment_SpecificationBean {
  @JsonKey(name: "Id")
  int? id;
  @JsonKey(name: "CustomValue")
  String? customValue;
  @JsonKey(name: "AdvertismentSpecificatioOptions")
  List<int?>? advertismentSpecificatioOptions;
  factory Advertisment_SpecificationBean.fromJson(Map<String, dynamic> json) => _$Advertisment_SpecificationBeanFromJson(json);
  Map<String, dynamic> toJson() => _$Advertisment_SpecificationBeanToJson(this);

  Advertisment_SpecificationBean({
      this.id, this.customValue, this.advertismentSpecificatioOptions});
}

@JsonSerializable()

class PhotosBean {
  @JsonKey(name: "Url")
  String? url;
  @JsonKey(name: "Id")
  int? id;

factory PhotosBean.fromJson(Map<String, dynamic> json) => _$PhotosBeanFromJson(json);



  PhotosBean(this.url, this.id);

  Map<String, dynamic> toJson() => _$PhotosBeanToJson(this);

}