import 'package:json_annotation/json_annotation.dart';
part 'field_proprtires_entity.g.dart';

@JsonSerializable()
class FieldProprtiresEntity {
	int CategoryId;
	dynamic Category;
	bool Required;
	int SpeceficationId;
	List<FieldProprtiresSpecificationoption> SpecificationOptions;
	int Id;
	bool HasRange;
	bool MuliSelect;
	dynamic CustomValue;
	String EnglishName;
	String ArabicName;

	FieldProprtiresEntity(this.CategoryId, this.Category, this.Required,
			this.SpeceficationId, this.SpecificationOptions, this.Id, this.HasRange,
			this.MuliSelect, this.CustomValue, this.EnglishName, this.ArabicName);

	factory FieldProprtiresEntity.fromJson(Map<String, dynamic> json) => _$FieldProprtiresEntityFromJson(json);

}
@JsonSerializable()
class FieldProprtiresSpecificationoption {
	bool IsSelected;
	int Id;
	String ArabicName;
	String EnglishName;

	FieldProprtiresSpecificationoption(this.IsSelected, this.Id, this.ArabicName,
			this.EnglishName);

	factory FieldProprtiresSpecificationoption.fromJson(Map<String, dynamic> json) => _$FieldProprtiresSpecificationoptionFromJson(json);

}
