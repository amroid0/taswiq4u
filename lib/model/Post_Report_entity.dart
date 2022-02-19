
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PostReport {
  @JsonKey(name: "Id")
  int? id;
  @JsonKey(name: "AdId")
  int? adId;
  @JsonKey(name: "Message")
  String? message;
  @JsonKey(name: "Reason")
  String? reason;
  @JsonKey(name: "CountryId")
  int? countryId;
  PostReport({
    this.id,
  this.adId,
  this.message,
  this.countryId,
  this.reason});

  factory PostReport.fromJson(Map<String, dynamic> json) => PostReport(
    id: json["Id"],
    adId: json["AdId"],
    message: json["Message"],
    reason: json["Reason"],
    countryId: json["CountryId"],
  );


  Map<String, dynamic> toJson() => _$AdsReportEntityToJson(this);
  Map<String, dynamic> _$AdsReportEntityToJson(PostReport instance) {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('Id', instance.id);
    val['Id'] = instance.id;
    val['AdId'] = instance.adId;
    val['Message'] = instance.message;
    val['Reason'] = instance.reason;
    val['CountryId'] = instance.countryId;
    return val;
  }
  PostReport _$AdsReportEntityFromJson(Map<String, dynamic> json) {
    return PostReport(
      id: json['Id'] as int?,
      adId: json['AdId'] as int?,
      message: json['Message'] as String?,
      reason: json['Reason'] as String?,
      countryId: json['CountryId'] as int?,
    );
  }


}


