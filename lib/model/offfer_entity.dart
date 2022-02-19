import 'dart:core';
import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
part 'offfer_entity.g.dart';
@JsonSerializable()
class OfferEntity{

  @JsonKey (name:"TotalItems" )
  int? totalItems;
  @JsonKey (name:"Page" )

  int? page;
  @JsonKey (name:"Size" )
  int? size;
  @JsonKey(name: "List")
  List<OfferDetail>? list;
  @JsonKey (name:"TotalPages" )
  int? totalPages;
  @JsonKey (name:"HasPreviousPage" )
  bool? hasPreviousPage;
  @JsonKey (name:"HasNextPage" )
  bool? hasNextPage;
  @JsonKey (name:"NextPage" )
  int? nextPage;
  @JsonKey (name:"PreviousPage" )
  int? previousPage;


  OfferEntity({this.totalItems, this.page, this.size, this.list, this.totalPages,
      this.hasPreviousPage, this.hasNextPage, this.nextPage, this.previousPage});

  factory OfferEntity.fromJson(Map<String, dynamic> json) => _$OfferEntityFromJson(json);


}
@JsonSerializable()
class OfferDetail {
  @JsonKey (name:"Id" )
  int? id;
  @JsonKey (name:"ImageId" )
  String? imageId;
  @JsonKey (name:"Type" )
  int? type;
  @JsonKey (name:"Description" )
  String? description;
  @JsonKey (name:"Link" )
  String? link;
  @JsonKey (name:"CreationDate" )
  String? creationDate;
  @JsonKey (name:"EndDate" )
  String? endDate;
  @JsonKey (name:"Active" )
  bool? active;
  @JsonKey (name:"Notification" )
  int? notification;
  @JsonKey (name:"CountryId" )
  int? countryId;
  @JsonKey (name:"ViewsCount" )
  int? viewsCount;
  @JsonKey (name:"Likes" )

  int? likes;
  @JsonKey (name:"CategoryId" )
  int? categoryId;
  @JsonKey (name:"Category" )
  Category? category;
  @JsonKey (name:"SystemDataFile" )
  dynamic systemDataFile;
  @JsonKey (name:"CommercialAdsUsers" )
  List<dynamic>? commercialAdsUsers;
  String? base64Image;

  OfferDetail({
      this.id,
      this.imageId,
      this.type,
      this.description,
      this.link,
      this.creationDate,
      this.endDate,
      this.active,
      this.notification,
      this.countryId,
      this.viewsCount,
      this.likes,
      this.categoryId,
      this.category,
      this.systemDataFile,
      this.commercialAdsUsers,
      this.base64Image});

  factory OfferDetail.fromJson(Map<String, dynamic> json) => _$OfferDetailFromJson(json);


}
@JsonSerializable()
class Category {
  @JsonKey (name:"Id" )
  int? id;
  @JsonKey (name:"Name" )
  String? name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json)  => _$CategoryFromJson(json);

}