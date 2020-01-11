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
  int Id;
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
  factory AdsPostEntity.fromJson(Map<String, dynamic> json) => _$AdsPostEntityFromJson(json);

  AdsPostEntity({this.Id, this.Title, this.ArabicDescription,
      this.EnglishDescription, this.Price, this.Phone, this.Email,
      this.IsNogitable, this.CategoryId, this.CountryId, this.CityId,
      this.StateId, this.LocationLongtude, this.LocationLatitude, this.UserId,
      this.IsNew, this.ContactMe, this.Photos, this.AdvertismentSpecification});
  Map<String, dynamic> toJson() => _$AdsPostEntityToJson(this);


}

/// Id : 0
/// AdvertismentSpecificatioOptions : [0]
@JsonSerializable()

class Advertisment_SpecificationBean {
  int Id;
  List<int> AdvertismentSpecificatioOptions;
  factory Advertisment_SpecificationBean.fromJson(Map<String, dynamic> json) => _$Advertisment_SpecificationBeanFromJson(json);
  Map<String, dynamic> toJson() => _$Advertisment_SpecificationBeanToJson(this);

  Advertisment_SpecificationBean({this.Id, this.AdvertismentSpecificatioOptions});

}

@JsonSerializable()

class PhotosBean {
  String Url;
  int Id;

factory PhotosBean.fromJson(Map<String, dynamic> json) => _$PhotosBeanFromJson(json);


  PhotosBean(this.Url, this.Id);

  Map<String, dynamic> toJson() => _$PhotosBeanToJson(this);

}