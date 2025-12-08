import 'dart:convert';
import 'dart:developer';

import 'package:flutter_posresto_app/data/models/response/product_response_model.dart';

class ProductQuantity {
  final Product product;
  int quantity;
  String note; // NEW: Note per item

  ProductQuantity({
    required this.product,
    required this.quantity,
    this.note = '', // Default empty
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductQuantity &&
        other.product == product &&
        other.quantity == quantity &&
        other.note == note;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode ^ note.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'note': note,
    };
  }

  Map<String, dynamic> toLocalMap(int orderId) {
    log("OrderProductId: ${product.id}");

    return {
      'id_order': orderId,
      'id_product': product.productId,
      'quantity': quantity,
      'price': product.price,
      'note': note,
    };
  }

  Map<String, dynamic> toServerMap(int? orderId) {
    log("toServerMap: ${product.id}");

    return {
      'id_order': orderId ?? 0,
      'product_id': product.id,
      'quantity': quantity,
      'price': product.price,
      'notes': note, // Map to 'notes' for backend
    };
  }

  factory ProductQuantity.fromMap(Map<String, dynamic> map) {
    return ProductQuantity(
      product: Product.fromMap(map['product']),
      quantity: map['quantity']?.toInt() ?? 0,
      note: map['note'] ?? '',
    );
  }

  factory ProductQuantity.fromLocalMap(Map<String, dynamic> map) {
    log("ProductQuantity: $map");
    return ProductQuantity(
      product: Product.fromOrderMap(map),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductQuantity.fromJson(String source) =>
      ProductQuantity.fromMap(json.decode(source));
}
