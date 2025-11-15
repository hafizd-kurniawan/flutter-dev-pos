import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';
import '../../core/helpers/api_helper.dart';

class StockRemoteDatasource {
  /// Get current stock for a single product
  Future<Either<String, Map<String, dynamic>>> getProductStock(int productId) async {
    final url = Uri.parse('${Variables.baseUrl}/api/stock/product/$productId');
    final headers = await ApiHelper.getHeaders();
    
    try {
      log('🔍 Checking stock for product $productId...');
      
      final response = await http.get(url, headers: headers);
      
      log('Stock API Status: ${response.statusCode}');
      log('Stock Response: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        log('✅ Stock check success: ${data['current_stock']} available');
        return Right(data);
      } else {
        return Left('Failed to get stock: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Stock check error: $e');
      return Left('Network error: $e');
    }
  }
  
  /// Check multiple products stock
  Future<Either<String, Map<String, dynamic>>> checkStock(List<int> productIds) async {
    final url = Uri.parse('${Variables.baseUrl}/api/stock/check');
    final headers = await ApiHelper.getHeaders();
    
    try {
      log('🔍 Checking stock for ${productIds.length} products...');
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'product_ids': productIds}),
      );
      
      log('Bulk Stock API Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        log('✅ Bulk stock check success');
        return Right(data);
      } else {
        return Left('Failed to check stock: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Bulk stock check error: $e');
      return Left('Network error: $e');
    }
  }
  
  /// Validate order items (check if sufficient stock for entire cart)
  Future<Either<String, Map<String, dynamic>>> validateOrder(List<Map<String, dynamic>> items) async {
    final url = Uri.parse('${Variables.baseUrl}/api/stock/validate-order');
    final headers = await ApiHelper.getHeaders();
    
    try {
      log('🔍 Validating order with ${items.length} items...');
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'items': items}),
      );
      
      log('Validate Order API Status: ${response.statusCode}');
      log('Validation Response: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final isValid = data['is_valid'] ?? false;
        
        if (isValid) {
          log('✅ Order validation passed');
        } else {
          log('❌ Order validation failed: ${data['message']}');
        }
        
        return Right(data);
      } else {
        return Left('Failed to validate order: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Order validation error: $e');
      return Left('Network error: $e');
    }
  }
}
