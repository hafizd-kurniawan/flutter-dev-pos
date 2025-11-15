import 'dart:developer';

import 'package:image_picker/image_picker.dart';

class ProductRequestModel {
  final String name;
  final int price;
  final int stock;
  final int categoryId;
  final int isBestSeller;
  final XFile? image;
  final String? printerType;
  ProductRequestModel({
    required this.name,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.isBestSeller,
    this.image,
    this.printerType,
  });

  Map<String, String> toMap() {
    log("toMap: $isBestSeller");
    return {
      'name': name,
      'price': price.toString(),
      'stock': stock.toString(),
      'category_id': categoryId.toString(),
      'is_best_seller': isBestSeller.toString(),
      'printer_type': printerType ?? '',
    };
  }
}
