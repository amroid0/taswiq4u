

import 'package:json_annotation/json_annotation.dart';
part 'ads_entity.g.dart';

@JsonSerializable()

class AdsEntity {





  // To parse this
  @JsonKey(name: "AdvertisementList")
  AdvertisementList advertisementList;
  @JsonKey(name: "CommercialAdsList")
  List<CommercialAdsList> commercialAdsList;

  AdsEntity({
  this.advertisementList,
  this.commercialAdsList,
  });
  factory AdsEntity.fromJson(Map<String, dynamic> json) => _$AdsEntityFromJson(json);


}
@JsonSerializable()

  class AdvertisementList {
  @JsonKey(name: "TotalItems")

  int totalItems;
  @JsonKey(name: "Page")

  int page;
  @JsonKey(name: "Size")
  int size;
  @JsonKey(name: "List")

  List<ListElement> list;
  @JsonKey(name: "TotalPages")

  int totalPages;
  @JsonKey(name: "HasPreviousPage")
  bool hasPreviousPage;
  @JsonKey(name: "HasNextPage")

  bool hasNextPage;
  @JsonKey(name: "NextPage")

  int nextPage;
  @JsonKey(name: "PreviousPage")
  int previousPage;

  AdvertisementList({
  this.totalItems,
  this.page,
  this.size,
  this.list,
  this.totalPages,
  this.hasPreviousPage,
  this.hasNextPage,
  this.nextPage,
  this.previousPage,
  });
  factory AdvertisementList.fromJson(Map<String, dynamic> json) => _$AdvertisementListFromJson(json);

}
@JsonSerializable()
  class ListElement {
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
  List<AdvertismentImage> AdvertismentImages;

  ListElement(this.Id, this.Title, this.ArabicDescription,
      this.EnglishDescription, this.IsNogitable, this.Price, this.CategoryId,
      this.CategoryName, this.UserId, this.UserName, this.UserPhone,
      this.ArabicDescriptionUrl, this.EnglishDescriptionUrl, this.ArabicTitle,
      this.EnglishTitle, this.CountryId, this.CountryNameEnglish,
      this.CountryNameArabic, this.LocationLatitude, this.LocationLongtude,
      this.IsDisplayed, this.IsDeleted, this.CreationTime, this.ViewCount,
      this.CityId, this.CityNameEnglish, this.CityNameArabic, this.StateId,
      this.StateNameArabic, this.StateNameEnglish, this.IsFeatured,
      this.AdvertismentImages);

  factory ListElement.fromJson(Map<String, dynamic> json) => _$ListElementFromJson(json);

  }
@JsonSerializable()
  class AdvertismentImage {
  int Id;
  String Url;
  int Size;
  bool IsImage;
  DateTime CreationDate;

  AdvertismentImage(this.Id, this.Url, this.Size, this.IsImage,
      this.CreationDate);

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
  int CommercialAdsCategoryId;
  @JsonKey(name:"CommercialAdsCategory" )
  CommercialAdsCategory commercialAdsCategory;
  @JsonKey(name:"SystemDataFile" )
  SystemDataFile systemDataFile;

  CommercialAdsList(this.Id, this.ImageId, this.Type, this.Description,
      this.Link, this.CreationDate, this.EndDate, this.Active,
      this.Notification, this.CountryId, this.ViewsCount, this.Likes,
      this.CommercialAdsCategoryId, this.commercialAdsCategory,
      this.systemDataFile);
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
  int Size;
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












