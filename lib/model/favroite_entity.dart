

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:olx/model/ads_entity.dart';
part 'favroite_entity.g.dart';

@JsonSerializable()
class FavoriteModel {
  int? Totalitems;
  int? Page;
  int? Size;
  @JsonKey(name: "List")
  List<AdsModel>? list;
  int? TotalPages;
  bool? HasPreviousPage;
  bool? HasNextPage;
  int? NextPage;
  int? PreviousPage;

  var isLoadMore;

  FavoriteModel(
      this.Totalitems,
      this.Page,
      this.Size,
      this.list,
      this.TotalPages,
      this.HasPreviousPage,
      this.HasNextPage,
      this.NextPage,
      this.PreviousPage);

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => _$FavoriteModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);
}
@JsonSerializable()
class FavAds {
  int? Id;
  String? Title;
  String? ArabicDescription;
  String? EnglishDescription;
  bool? IsNogitable;
  double? Price;
  int? CategoryId;
  String? CategoryName;
  String? UserId;
  String? UserName;
  String? UserPhone;
  String? ArabicDescriptionUrl;
  String? EnglishDescriptionUrl;
  String? ArabicTitle;
  String? EnglishTitle;
  int? CountryId;
  String? CountryNameEnglish;
  String? CountryNameArabic;
  double? LocationLatitude;
  double? LocationLongtude;
  bool? IsDisplayed;
  bool? IsDeleted;
  DateTime? CreationTime;
  int? ViewCount;
  int? CityId;
  String? CityNameEnglish;
  String? CityNameArabic;
  int? StateId;
  String? StateNameArabic;
  String? StateNameEnglish;
  bool? IsFeatured;
  bool? IsFavorite;
  List<AdvertismentImage>? AdvertismentImages;

  FavAds(
      this.Id,
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
      this.AdvertismentImages);

  factory FavAds.fromJson(Map<String, dynamic> json) =>_$FavAdsFromJson(json);

  Map<String, dynamic> toJson() =>_$FavAdsToJson(this);
}
