import 'package:json_annotation/json_annotation.dart';
import 'package:olx/model/ads_entity.dart';
part 'ads_detail.g.dart';

@JsonSerializable()
class AdsDetail {

  int Id;
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
  String CreationTime;
  String UpdateTime;
  int ViewCount;
  int CityId;
  String CityNameEnglish;
  String CityNameArabic;
  int StateId;
  String StateNameArabic;
  String StateNameEnglish;
  bool IsFavorite;
  bool IsActive;
  List<AdvertismentSpecification> Advertisment_Specification;
  List<AdvertismentImage> AdvertismentImages;

	AdsDetail({this.Id, this.ArabicDescription, this.EnglishDescription,
			this.IsNogitable, this.Price, this.CategoryId, this.CategoryName,
			this.UserId, this.UserName, this.UserPhone, this.ArabicDescriptionUrl,
			this.EnglishDescriptionUrl, this.ArabicTitle, this.EnglishTitle,
			this.CountryId, this.CountryNameEnglish, this.CountryNameArabic,
			this.LocationLatitude, this.LocationLongtude, this.IsDisplayed,
			this.IsDeleted, this.CreationTime, this.UpdateTime, this.ViewCount,
			this.CityId, this.CityNameEnglish, this.CityNameArabic, this.StateId,
			this.StateNameArabic, this.StateNameEnglish, this.IsFavorite,
			this.IsActive, this.Advertisment_Specification, this.AdvertismentImages});

  factory AdsDetail.fromJson(Map<String, dynamic> json) => _$AdsDetailFromJson(json);

}
@JsonSerializable()
class AdvertismentSpecification {

	int Id;
	int CategoryId;
	int AdvertismentId;
	int CategorySpecificationId;
	String NameEnglish;
	String NameArabic;
	String CustomValue;
	List<AdsSpecificatioOptions> AdvertismentSpecificatioOptions;
	String CategorySpecificationVM;
	String AdvertismentSpecificationOptions;

	AdvertismentSpecification({this.Id, this.CategoryId, this.AdvertismentId,
			this.CategorySpecificationId, this.NameEnglish, this.NameArabic,
			this.CustomValue, this.AdvertismentSpecificatioOptions,
			this.CategorySpecificationVM, this.AdvertismentSpecificationOptions});

  factory AdvertismentSpecification.fromJson(Map<String, dynamic> json) => _$AdvertismentSpecificationFromJson(json);

}

@JsonSerializable()
class AdsSpecificatioOptions {

	int Id;
	String AdvertismentSpecificationId;
	String NameEnglish;
	String NameArabic;
	int SpecificationOptionId;

	AdsSpecificatioOptions({this.Id, this.AdvertismentSpecificationId,
			this.NameEnglish, this.NameArabic, this.SpecificationOptionId});
  factory AdsSpecificatioOptions.fromJson(Map<String, dynamic> json) => _$AdsSpecificatioOptionsFromJson(json);

}

