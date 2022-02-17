// To parse this JSON data, do
//
//     final cities = citiesFromMap(jsonString);

import 'dart:convert';

List<Cities> citiesFromMap(String str) => List<Cities>.from(json.decode(str).map((x) => Cities.fromMap(x)));

String citiesToMap(List<Cities> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Cities {
  Cities({
    this.id,
    this.cityId,
    this.arabicName,
    this.englishName,
    this.name,
    this.cityCityId,
    this.countryId,
  });

  String id;
  int cityId;
  String arabicName;
  String englishName;
  String name ;
  int cityCityId;
  int countryId;

  factory Cities.fromMap(Map<String, dynamic> json) => Cities(
    id: json["\u0024id"] == null ? null : json["\u0024id"],
    cityId: json["Id"] == null ? null : json["Id"],
    arabicName: json["ArabicName"] == null ? null : json["ArabicName"],
    englishName: json["EnglishName"] == null ? null : json["EnglishName"],
    cityCityId: json["CityId"] == null ? null : json["CityId"],
    countryId: json["CountryId"] == null ? null : json["CountryId"],
  );

  Map<String, dynamic> toMap() => {
    "\u0024id": id == null ? null : id,
    "Id": cityId == null ? null : cityId,
    "ArabicName": arabicName == null ? null : arabicName,
    "EnglishName": englishName == null ? null : englishName,
    "CityId": cityCityId == null ? null : cityCityId,
    "CountryId": countryId == null ? null : countryId,
  };
}
