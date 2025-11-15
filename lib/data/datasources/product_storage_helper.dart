import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/response/product_response_model.dart';

/// Helper class for storing products in SharedPreferences
/// Used for web platform where SQLite is not available
class ProductStorageHelper {
  static const String _key = 'cached_products';
  
  /// Save products to SharedPreferences
  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((p) => p.toMap()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }
  
  /// Get products from SharedPreferences
  static Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Product.fromMap(json)).toList();
    } catch (e) {
      // If parsing fails, return empty list
      return [];
    }
  }
  
  /// Clear all cached products
  static Future<void> clearProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
