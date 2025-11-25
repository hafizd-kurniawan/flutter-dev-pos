// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

class TableModel {
  final int? id;
  final String name;
  final int? categoryId;
  final String? categoryName;
  final String? description;
  final String? location;
  final int capacity;
  final int? partySize;
  final String status; // available, occupied, reserved, pending_bill
  final String? customerName;
  final String? customerPhone;
  final int? orderId;
  final double? paymentAmount;
  final double xPosition;
  final double yPosition;
  final DateTime? occupiedAt;
  final DateTime? lastActivity;
  final String? specialNotes;

  TableModel({
    this.id,
    required this.name,
    this.categoryId,
    this.categoryName,
    this.description,
    this.location,
    required this.capacity,
    this.partySize,
    required this.status,
    this.customerName,
    this.customerPhone,
    this.orderId,
    this.paymentAmount,
    this.xPosition = 0,
    this.yPosition = 0,
    this.occupiedAt,
    this.lastActivity,
    this.specialNotes,
  });

  @override

  // From API JSON
  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      name: json['name'] ?? json['table_name'] ?? '',
      categoryId: json['category_id'],
      categoryName: json['category']?['name'],
      description: json['description'],
      location: json['location'],
      capacity: json['capacity'] ?? 2,
      partySize: json['party_size'],
      status: json['status'] ?? 'available',
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      orderId: json['order_id'],
      paymentAmount: json['payment_amount'] != null 
          ? double.tryParse(json['payment_amount'].toString()) 
          : null,
      xPosition: json['x_position'] != null 
          ? double.tryParse(json['x_position'].toString()) ?? 0 
          : 0,
      yPosition: json['y_position'] != null 
          ? double.tryParse(json['y_position'].toString()) ?? 0 
          : 0,
      occupiedAt: json['occupied_at'] != null 
          ? DateTime.tryParse(json['occupied_at']) 
          : null,
      lastActivity: json['last_activity'] != null 
          ? DateTime.tryParse(json['last_activity']) 
          : null,
      specialNotes: json['special_notes'],
    );
  }

  // For backward compatibility with local database
  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel.fromJson(map);
  }

  // To JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'description': description,
      'location': location,
      'capacity': capacity,
      'party_size': partySize,
      'status': status,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'order_id': orderId,
      'payment_amount': paymentAmount,
      'x_position': xPosition,
      'y_position': yPosition,
      'special_notes': specialNotes,
    };
  }

  // For backward compatibility
  Map<String, dynamic> toMap() {
    return toJson();
  }

  // Helper getters
  Offset get position => Offset(xPosition, yPosition);
  String get tableName => name; // Backward compatibility

  // copyWith for updates
  TableModel copyWith({
    int? id,
    String? name,
    int? categoryId,
    String? categoryName,
    String? description,
    String? location,
    int? capacity,
    int? partySize,
    String? status,
    String? customerName,
    String? customerPhone,
    int? orderId,
    double? paymentAmount,
    double? xPosition,
    double? yPosition,
    DateTime? occupiedAt,
    DateTime? lastActivity,
    String? specialNotes,
  }) {
    return TableModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      partySize: partySize ?? this.partySize,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      orderId: orderId ?? this.orderId,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      xPosition: xPosition ?? this.xPosition,
      yPosition: yPosition ?? this.yPosition,
      occupiedAt: occupiedAt ?? this.occupiedAt,
      lastActivity: lastActivity ?? this.lastActivity,
      specialNotes: specialNotes ?? this.specialNotes,
    );
  }

  @override
  bool operator ==(covariant TableModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.status == status &&
        other.capacity == capacity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        status.hashCode ^
        capacity.hashCode;
  }
}
