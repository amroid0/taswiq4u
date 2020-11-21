 import 'package:json_annotation/json_annotation.dart';

import 'cateogry_entity.dart';
 part 'country_entity.g.dart';

 @JsonSerializable()

class CountryEntity{
   @JsonKey(name: "Id")
   String id;
   @JsonKey(name: "CountryId")
   int countryId;
   @JsonKey(name: "ArabicDescription")
   String arabicDescription;
   @JsonKey(name: "EnglishDescription")
   String englishDescription;
   @JsonKey(name: "Name")
   String name;
   @JsonKey(name: "Flag")
   String flag;
   @JsonKey(name: "FeaturedAdCost")
   double featuredAdCost;
   @JsonKey(name: "FreeAdCount")
   int freeAdCount;
   @JsonKey(name: "PhoneKey")
   String phoneKey;
   @JsonKey(name: "imageId")
   int imageId;
   @JsonKey(name: "Currency")
   Currency currency;
   @JsonKey(name: "Language")
   Language language;
   @JsonKey(name: "Abbr")
   String abbr;
   @JsonKey(name: "Categories")
   List<CateogryEntity> categories;

   CountryEntity(
   {this.id,
   this.countryId,
   this.arabicDescription,
   this.englishDescription,
   this.name,
   this.flag,
   this.featuredAdCost,
   this.freeAdCount,
   this.phoneKey,
   this.imageId,
   this.currency,
   this.language,
   this.abbr,
   this.categories});
   factory CountryEntity.fromJson(Map<String, dynamic> json) => _$CountryEntityFromJson(json);
   Map<String, dynamic> toJson() => _$CountryEntityToJson(this);


 }
 @JsonSerializable()

 class Currency {
   @JsonKey(name: "Id")
   int id;
   @JsonKey(name: "Name")
   String name;
   @JsonKey(name: "Abbr")
   String abbr;

   Currency({ this.id, this.name, this.abbr});

   factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
   Map<String, dynamic> toJson() => _$CurrencyToJson(this);
 }
 @JsonSerializable()

 class Language {
   @JsonKey(name: "Id")
   int id;
   @JsonKey(name: "Name")
   String name;
   @JsonKey(name: "Active")
   bool active;
   Language({this.id, this.name, this.active});

   factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
   Map<String, dynamic> toJson() => _$LanguageToJson(this);
 }


