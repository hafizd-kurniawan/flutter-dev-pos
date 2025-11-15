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
  final int? serviceChargeAmount;
  final int totalAmount;
  final String status;
  final String paymentMethod;
  final String? placedAt;
  final String? completedAt;
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
    this.serviceChargeAmount,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.placedAt,
    this.completedAt,
    required this.orderItems,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      tableNumber: json['table_number']?.toString(),
      subtotal: _parseToInt(json['subtotal']),
      discountAmount: _parseToInt(json['discount_amount']),
      taxAmount: _parseToInt(json['tax_amount']),
      serviceChargeAmount: _parseToInt(json['service_charge_amount']),
      totalAmount: _parseToInt(json['total_amount']),
      status: json['status'] ?? 'paid',
      paymentMethod: json['payment_method'] ?? 'cash',
      placedAt: json['placed_at'],
      completedAt: json['completed_at'],
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
      'service_charge_amount': serviceChargeAmount,
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'placed_at': placedAt,
      'completed_at': completedAt,
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
