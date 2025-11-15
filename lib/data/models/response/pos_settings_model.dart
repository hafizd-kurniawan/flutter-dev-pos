import 'dart:convert';

class PosSettingsModel {
  final List<SettingItem> discounts;
  final List<SettingItem> taxes;
  final List<SettingItem> services;

  PosSettingsModel({
    required this.discounts,
    required this.taxes,
    required this.services,
  });

  factory PosSettingsModel.fromJson(String str) =>
      PosSettingsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PosSettingsModel.fromMap(Map<String, dynamic> json) {
    return PosSettingsModel(
      discounts: json['discounts'] != null
          ? List<SettingItem>.from(
              (json['discounts'] as List).map((x) => SettingItem.fromMap(x)))
          : [],
      taxes: json['taxes'] != null
          ? List<SettingItem>.from(
              (json['taxes'] as List).map((x) => SettingItem.fromMap(x)))
          : [],
      services: json['services'] != null
          ? List<SettingItem>.from(
              (json['services'] as List).map((x) => SettingItem.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discounts': discounts.map((x) => x.toMap()).toList(),
      'taxes': taxes.map((x) => x.toMap()).toList(),
      'services': services.map((x) => x.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'PosSettingsModel(discounts: ${discounts.length}, taxes: ${taxes.length}, services: ${services.length})';
  }
}

class SettingItem {
  final int id;
  final String name;
  final String type;
  final num value;
  final String? description;

  SettingItem({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    this.description,
  });

  factory SettingItem.fromJson(String str) =>
      SettingItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SettingItem.fromMap(Map<String, dynamic> json) {
    return SettingItem(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      value: json['value'] as num,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'value': value,
      'description': description,
    };
  }

  // Display text for UI (dialog subtitle)
  String get displayText {
    if (type == 'percentage') {
      return '$value%';
    } else if (type == 'fixed') {
      return 'Rp ${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    } else {
      // For tax and service (default to percentage)
      return '$value%';
    }
  }
  
  // Display text with name
  String get displayTextWithName {
    if (type == 'percentage') {
      return '$name ($value%)';
    } else if (type == 'fixed') {
      return '$name (Rp ${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    } else {
      return '$name ($value%)';
    }
  }

  @override
  String toString() {
    return 'SettingItem(id: $id, name: $name, type: $type, value: $value)';
  }
}
