import 'dart:convert';

class SettingsResponseModel {
  final bool success;
  final SettingsData data;

  SettingsResponseModel({
    required this.success,
    required this.data,
  });

  factory SettingsResponseModel.fromJson(String str) =>
      SettingsResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SettingsResponseModel.fromMap(Map<String, dynamic> json) =>
      SettingsResponseModel(
        success: json["success"],
        data: SettingsData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": data.toMap(),
      };
}

class SettingsData {
  final Map<String, SettingItem> settings;
  final int tenantId;

  SettingsData({
    required this.settings,
    required this.tenantId,
  });

  factory SettingsData.fromMap(Map<String, dynamic> json) => SettingsData(
        settings: Map.from(json["settings"]).map((k, v) =>
            MapEntry<String, SettingItem>(k, SettingItem.fromMap(v))),
        tenantId: json["tenant_id"],
      );

  Map<String, dynamic> toMap() => {
        "settings": Map.from(settings)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "tenant_id": tenantId,
      };
}

class SettingItem {
  final String value;
  final String type;
  final String label;

  SettingItem({
    required this.value,
    required this.type,
    required this.label,
  });

  factory SettingItem.fromMap(Map<String, dynamic> json) => SettingItem(
        value: json["value"] ?? '',
        type: json["type"] ?? 'text',
        label: json["label"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "type": type,
        "label": label,
      };
}
