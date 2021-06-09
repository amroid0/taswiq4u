

import 'package:json_annotation/json_annotation.dart';
part 'ads_entity.g.dart';

@JsonSerializable()

class AdsEntity {

  String $id;

  @JsonKey(name: "AdvertisementList")
  List<AdsModel> advertisementList;
  @JsonKey(name: "CommercialAdsList")
  List<CommercialAdsList> commercialAdsList;

  bool isLoadMore;

  AdsEntity({this.$id,
  this.advertisementList,
  this.commercialAdsList,
  });
  factory AdsEntity.fromJson(Map<String, dynamic> json) => _$AdsEntityFromJson(json);


}

@JsonSerializable()
  class AdsModel {
  int Id;
  String Title;
  String ArabicDescription;
  String EnglishDescription;
  bool IsNogitable;
  double Price;
  int CategoryId;
  String CategoryName;
  String UserId;
  String UserName;
  String UserPhone;
  String ArabicDescriptionUrl;
  String EnglishDescriptionUrl;
  String ArabicTitle;
  String EnglishTitle;
  int CountryId;
  String CountryNameEnglish;
  String CountryNameArabic;
  double LocationLatitude;
  double LocationLongtude;
  bool IsDisplayed;
  bool IsDeleted;
  DateTime CreationTime;
  int ViewCount;
  int CityId;
  String CityNameEnglish;
  String CityNameArabic;
  int StateId;
  String StateNameArabic;
  String StateNameEnglish;
  bool IsFeatured;
  bool IsFavorite;
  List<AdvertismentImage> AdvertismentImages;

  AdsModel(
      {this.Id,
      this.Title,
      this.ArabicDescription,
      this.EnglishDescription,
      this.IsNogitable,
      this.Price,
      this.CategoryId,
      this.CategoryName,
      this.UserId,
      this.UserName,
      this.UserPhone,
      this.ArabicDescriptionUrl,
      this.EnglishDescriptionUrl,
      this.ArabicTitle,
      this.EnglishTitle,
      this.CountryId,
      this.CountryNameEnglish,
      this.CountryNameArabic,
      this.LocationLatitude,
      this.LocationLongtude,
      this.IsDisplayed,
      this.IsDeleted,
      this.CreationTime,
      this.ViewCount,
      this.CityId,
      this.CityNameEnglish,
      this.CityNameArabic,
      this.StateId,
      this.StateNameArabic,
      this.StateNameEnglish,
      this.IsFeatured,
      this.IsFavorite,
      this.AdvertismentImages});

  factory AdsModel.fromJson(Map<String, dynamic> json) => _$AdsModelFromJson(json);

  }
@JsonSerializable()
  class AdvertismentImage {
  int Id;
  String Url;
  double Size;
  bool IsImage;
  DateTime CreationDate;
  String base64Image="";
  bool isLoading=false;

  AdvertismentImage(this.Id, this.Url, this.Size, this.IsImage,
      this.CreationDate,this.base64Image);

  factory AdvertismentImage.fromJson(Map<String, dynamic> json) => _$AdvertismentImageFromJson(json);

}
@JsonSerializable()

  class CommercialAdsList {
  int Id;
  int ImageId;
  int Type;
  String Description;
  String Link;
  DateTime CreationDate;
  DateTime EndDate;
  bool Active;
  int Notification;
  int CountryId;
  int ViewsCount;
  int Likes;
  bool isLiked;
  bool isViewed;
  int CommercialAdsCategoryId;
  @JsonKey(name:"CommercialAdsCategory" )
  CommercialAdsCategory commercialAdsCategory;
  @JsonKey(name:"SystemDataFile" )
  SystemDataFile systemDataFile;
  String base64Image;
  bool isLoading=false;

  CommercialAdsList(this.Id, this.ImageId, this.Type, this.Description,
      this.Link, this.CreationDate, this.EndDate, this.Active,
      this.Notification, this.CountryId, this.ViewsCount, this.Likes,
      this.CommercialAdsCategoryId, this.commercialAdsCategory,
      this.systemDataFile,
      this.base64Image,
      );
  factory CommercialAdsList.fromJson(Map<String, dynamic> json) => _$CommercialAdsListFromJson(json);


}
@JsonSerializable()
  class CommercialAdsCategory {
  String NameAr;
  String NameEn;
  int CountryId;
  List<ComercialAd> ComercialAds;

  CommercialAdsCategory(this.NameAr, this.NameEn, this.CountryId,
      this.ComercialAds);
  factory CommercialAdsCategory.fromJson(Map<String, dynamic> json) => _$CommercialAdsCategoryFromJson(json);


}
@JsonSerializable()

  class ComercialAd {
  ComercialAd();
  factory ComercialAd.fromJson(Map<String, dynamic> json) => _$ComercialAdFromJson(json);

  }
@JsonSerializable()
  class SystemDataFile {
  int Id;
  String Url;
  double Size;
  String Extention;
  int Type;
  DateTime CreationDate;
  bool IsDeleted;
  bool IsAssinged;
  List<ComercialAd> ComercialAds;

  SystemDataFile(this.Id, this.Url, this.Size, this.Extention, this.Type,
      this.CreationDate, this.IsDeleted, this.IsAssinged, this.ComercialAds);

  factory SystemDataFile.fromJson(Map<String, dynamic> json) => _$SystemDataFileFromJson(json);

}












