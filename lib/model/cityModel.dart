import 'package:json_annotation/json_annotation.dart';
part 'cityModel.g.dart';

@JsonSerializable()

class CityModel{
  @JsonKey(name: "Id")
  int id;
  @JsonKey(name: "CountryId")
  int countryId;
  @JsonKey(name: "ArabicName")
  String arabicDescription;
  @JsonKey(name: "EnglishName")
  String englishDescription;
  @JsonKey(name: "Name")
  String name;
  @JsonKey(name: "Flag")
  String flag;


  CityModel(
      {this.id,
        this.countryId,
        this.arabicDescription,
        this.englishDescription,
        this.name,
        this.flag,});
  factory CityModel.fromJson(Map<String, dynamic> json) =>_$CityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CityModelToJson(this);


}