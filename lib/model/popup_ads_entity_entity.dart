import 'package:json_annotation/json_annotation.dart';
part 'popup_ads_entity_entity.g.dart';

@JsonSerializable()
class PopupAdsEntityList  {
	String? $id;
	@JsonKey(name: "Id")
	int? id;
	int? imageId;
	@JsonKey(name: "Type")
	int? type;
	@JsonKey(name: "Description")
	String? description;
	@JsonKey(name: "Link")
	String? link;
	@JsonKey(name: "CreationDate")
	String? creationDate;
	@JsonKey(name: "EndDate")
	String? endDate;
	@JsonKey(name: "Active")
	bool? active;
	@JsonKey(name: "Notification")
	int? notification;
	@JsonKey(name: "CountryId")
	int? countryId;
	@JsonKey(name: "ViewsCount")
	int? viewsCount;
	@JsonKey(name: "Likes")
	int? likes;
	@JsonKey(name: "CategoryId")
	int? categoryId;
	@JsonKey(name: "InstagramLink")
	String? instagramLink;
	@JsonKey(name: "PhoneNumber")
	String? phoneNumber;

	@JsonKey(name: "Category")
	PopupAdsEntityListCategory? category;
	@JsonKey(name: "SystemDataFile")
	PopupAdsEntityListSystemDataFile? systemDataFile;
	@JsonKey(name: "CommercialAdsUsers")
	List<dynamic>? commercialAdsUsers;

	PopupAdsEntityList(this.$id, this.id, this.imageId, this.type,
			this.description, this.link, this.creationDate, this.endDate, this.active,
			this.notification, this.countryId, this.viewsCount, this.likes,
			this.categoryId, this.category, this.systemDataFile,this.instagramLink,this.phoneNumber,
			this.commercialAdsUsers);
	factory PopupAdsEntityList.fromJson(Map<String, dynamic> json) => _$PopupAdsEntityListFromJson(json);

}
@JsonSerializable()
class PopupAdsEntityListCategory {
	String? $id;
	@JsonKey(name: "Id")
	int? id;
	@JsonKey(name: "Name")
	String? name;
	@JsonKey(name: "CategoryLogo")
	String? categoryLogo;

	PopupAdsEntityListCategory(this.$id, this.id, this.name, this.categoryLogo);
	factory PopupAdsEntityListCategory.fromJson(Map<String, dynamic> json) => _$PopupAdsEntityListCategoryFromJson(json);

}
@JsonSerializable()
class PopupAdsEntityListSystemDataFile {
	String? $id;
	@JsonKey(name: "Id")
	int? id;
	@JsonKey(name: "Url")
	String? url;
	@JsonKey(name: "Size")
	double? size;
	@JsonKey(name: "Extention")
	String? extention;
	@JsonKey(name: "Type")
	int? type;
	@JsonKey(name: "CreationDate")
	String? creationDate;
	@JsonKey(name: "IsDeleted")
	bool? isDeleted;
	@JsonKey(name: "IsAssinged")
	dynamic isAssinged;

	PopupAdsEntityListSystemDataFile(this.$id, this.id, this.url, this.size,
			this.extention, this.type, this.creationDate, this.isDeleted,
			this.isAssinged);
	factory PopupAdsEntityListSystemDataFile.fromJson(Map<String, dynamic> json) => _$PopupAdsEntityListSystemDataFileFromJson(json);

}
