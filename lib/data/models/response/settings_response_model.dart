import 'dart:convert';

class SettingsResponseModel {
  final Map<String, dynamic> data;

  SettingsResponseModel({
    required this.data,
  });

  factory SettingsResponseModel.fromJson(String str) =>
      SettingsResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SettingsResponseModel.fromMap(Map<String, dynamic> json) =>
      SettingsResponseModel(
        data: json["data"] ?? {},
      );

  Map<String, dynamic> toMap() => {
        "data": data,
      };
}
