import 'package:json_annotation/json_annotation.dart';
part 'ads_params.g.dart';

@JsonSerializable()
class AdsParams {

  int? CountryId;
  int? CityId;
  int? CategoryId;

	AdsParams({this.CountryId, this.CityId, this.CategoryId});

  factory AdsParams.fromJson(Map<String, dynamic> json) =>
      _$AdsParamsFromJson(json);


  Map<String, dynamic> toJson() => _$AdsParamsToJson(this);

}
