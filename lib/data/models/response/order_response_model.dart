import 'dart:convert';

class OrderResponseModel {
  final int id;
  final String code;
  final String? customerName;
  final String? customerPhone;
  final String? tableNumber;
  final int subtotal;
  final int? discountAmount;
  final int? taxAmount;
  final int? taxPercentage;
  final int? serviceChargeAmount;
  final int? serviceChargePercentage;
  final int totalAmount;
  final String status;
  final String paymentMethod;
  final String? placedAt;
  final String? completedAt;

  final String? orderType; // NEW: 'dine_in', 'takeaway', or 'self_order'
  final String? cashierName; // NEW
  final String? note; // NEW: Global Order Note
  final List<OrderItemResponseModel> orderItems;

  OrderResponseModel({
    required this.id,
    required this.code,
    this.customerName,
    this.customerPhone,
    this.tableNumber,
    required this.subtotal,
    this.discountAmount,
    this.taxAmount,
    this.taxPercentage,
    this.serviceChargeAmount,
    this.serviceChargePercentage,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.placedAt,
    this.completedAt,

    this.orderType, // NEW
    this.cashierName, // NEW
    this.note, // NEW: Global Order Note
    required this.orderItems,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    // Parse table name from table relation or table_number field
    String? tableName;
    if (json['table'] != null && json['table'] is Map) {
      tableName = json['table']['name']?.toString();
    } else if (json['table_number'] != null) {
      tableName = json['table_number'].toString();
    }
    
    return OrderResponseModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      tableNumber: tableName,
      subtotal: _parseToInt(json['subtotal']),
      discountAmount: _parseToInt(json['discount_amount']),
      taxAmount: _parseToInt(json['tax_amount']),
      taxPercentage: _parseToInt(json['tax_percentage']),
      serviceChargeAmount: _parseToInt(json['service_charge_amount']),
      serviceChargePercentage: _parseToInt(json['service_charge_percentage']),
      totalAmount: _parseToInt(json['total_amount']),
      status: json['status'] ?? 'paid',
      paymentMethod: json['payment_method'] ?? 'cash',
      placedAt: json['placed_at'],
      completedAt: json['completed_at'],

      orderType: json['order_type'], // NEW: Parse from backend
      cashierName: json['cashier_name'], // NEW: Parse from backend
      note: json['notes'], // NEW: Parse from backend (mapped to 'notes' in Laravel)
      orderItems: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((item) => OrderItemResponseModel.fromJson(item))
              .toList()
          : [],
    );
  }

  // Helper to parse string/int/double to int
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return double.tryParse(value)?.toInt() ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'table_number': tableNumber,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'tax_percentage': taxPercentage,
      'service_charge_amount': serviceChargeAmount,
      'service_charge_percentage': serviceChargePercentage,
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'placed_at': placedAt,
      'completed_at': completedAt,

      'order_type': orderType, // NEW
      'cashier_name': cashierName, // NEW
      'notes': note, // NEW
      'order_items': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItemResponseModel {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final int price;
  final int total;
  final String? note;

  OrderItemResponseModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
    this.note,
  });

  factory OrderItemResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderItemResponseModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product']?['name'] ?? json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: _parseToInt(json['price']),
      total: _parseToInt(json['total']),
      note: json['note'],
    );
  }

  // Helper to parse string/int/double to int
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return double.tryParse(value)?.toInt() ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'total': total,
      'note': note,
    };
  }
}

class OrdersListResponseModel {
  final List<OrderResponseModel> data;

  OrdersListResponseModel({required this.data});

  factory OrdersListResponseModel.fromJson(String str) {
    final json = jsonDecode(str);
    return OrdersListResponseModel(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((order) => OrderResponseModel.fromJson(order))
              .toList()
          : [],
    );
  }
}
