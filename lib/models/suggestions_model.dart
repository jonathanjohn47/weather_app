// To parse this JSON data, do
//
//     final suggestionsModel = suggestionsModelFromJson(jsonString);

import 'dart:convert';

List<SuggestionsModel> suggestionsModelFromJson(String str) => List<SuggestionsModel>.from(json.decode(str).map((x) => SuggestionsModel.fromJson(x)));

String suggestionsModelToJson(List<SuggestionsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SuggestionsModel {
  int id;
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String url;

  SuggestionsModel({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  SuggestionsModel copyWith({
    int? id,
    String? name,
    String? region,
    String? country,
    double? lat,
    double? lon,
    String? url,
  }) =>
      SuggestionsModel(
        id: id ?? this.id,
        name: name ?? this.name,
        region: region ?? this.region,
        country: country ?? this.country,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        url: url ?? this.url,
      );

  factory SuggestionsModel.fromJson(Map<String, dynamic> json) => SuggestionsModel(
    id: json["id"],
    name: json["name"],
    region: json["region"],
    country: json["country"],
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "region": region,
    "country": country,
    "lat": lat,
    "lon": lon,
    "url": url,
  };
}
