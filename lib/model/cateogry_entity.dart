import 'package:json_annotation/json_annotation.dart';
part 'cateogry_entity.g.dart';

@JsonSerializable()

class CateogryEntity {
	@JsonKey(name:"CountryId")
	int countryId;
	@JsonKey(name:"ArabicDescription")
	String arabicDescription;
	@JsonKey(name:"EnglishDescription")
	String englishDescription;
	@JsonKey(name:"IsActive")
	bool isActive;
	@JsonKey(name:"CategoryLevel")
	int categoryLevel;
	@JsonKey(name:"CategoryLogo")
	String categoryLogo;
	@JsonKey(name:"ImageUrl")
	String imageUrl;
	@JsonKey(name:"imageId")
	String imageId;
	@JsonKey(name:"Id")
	int id;
	@JsonKey(name:"SubCats")
	String subCats;
	@JsonKey(name:"SubCategories")
	List<CateogryEntity> subCategories;
	@JsonKey(name:"Name")
	String name;
	@JsonKey(name:"HasSub")
	bool hasSub;
	@JsonKey(name:"HasHorizontalMenu")
	bool hasHorizontal;

	bool isSelected=false;

	CateogryEntity({this.countryId, this.arabicDescription, this.englishDescription, this.isActive, this.categoryLevel, this.categoryLogo, this.imageUrl, this.id, this.subCats, this.subCategories, this.name, this.hasSub,this.isSelected=false,this.hasHorizontal});
	factory CateogryEntity.fromJson(Map<String, dynamic> json) => _$CateogryEntityFromJson(json);
	Map<String, dynamic> toJson() => _$CateogryEntityToJson(this);


}

