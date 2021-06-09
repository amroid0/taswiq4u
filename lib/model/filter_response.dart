
import 'package:json_annotation/json_annotation.dart';
part 'filter_response.g.dart';

@JsonSerializable()
class FilterParamsEntity {
	double priceMin;
	double priceMax;
	bool isNew;
	int countryId;
	int cityId;
	int stateId;
	int categoryId;
	String key;
	@JsonKey(ignore: true)
	String cateName;
	List<Params> params;
	@JsonKey(ignore: true)
  String cityName;

	FilterParamsEntity(
			{this.priceMin,
				this.priceMax,
				this.isNew,
				this.countryId,
				this.cityId,
				this.stateId,
				this.categoryId,
				this.key,
				this.params,this.cateName,this.cityName});
	factory FilterParamsEntity.fromJson(Map<String, dynamic> json) => _$FilterParamsEntityFromJson(json);
	Map<String, dynamic> toJson() => _$FilterParamsEntityToJson(this);

}
@JsonSerializable()
class Params {
	int specificationId;
	List<int> options;
	bool hasOptions;
	String value;
	bool hasRange;
	int min;
	int max;

	Params(
			{this.specificationId,
				this.options,
				this.hasOptions,
				this.value,
				this.hasRange,
				this.min,
				this.max});


	factory Params.fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
	Map<String, dynamic> toJson() => _$ParamsToJson(this);

}