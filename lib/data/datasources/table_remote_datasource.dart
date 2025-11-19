import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:flutter_posresto_app/data/models/response/table_category_model.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TableRemoteDatasource {
  // Get all tables
  Future<Either<String, List<TableModel>>> getTables() async {
    final headers = await ApiHelper.getHeaders();
    
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/tables'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      final tables = data.map((json) => TableModel.fromJson(json)).toList();
      return Right(tables);
    } else {
      return Left('Failed to load tables: ${response.statusCode}');
    }
  }

  // Get available tables only
  Future<Either<String, List<TableModel>>> getAvailableTables() async {
    final headers = await ApiHelper.getHeaders();
    
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/tables-available'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      final tables = data.map((json) => TableModel.fromJson(json)).toList();
      return Right(tables);
    } else {
      return Left('Failed to load available tables: ${response.statusCode}');
    }
  }

  // Get tables by category
  Future<Either<String, List<TableModel>>> getTablesByCategory(int categoryId) async {
    final headers = await ApiHelper.getHeaders();
    
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/tables-by-category?category_id=$categoryId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      final tables = data.map((json) => TableModel.fromJson(json)).toList();
      return Right(tables);
    } else {
      return Left('Failed to load tables by category: ${response.statusCode}');
    }
  }

  // Get table categories
  Future<Either<String, List<TableCategoryModel>>> getCategories() async {
    final headers = await ApiHelper.getHeaders();
    
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/table-categories'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      final categories = data.map((json) => TableCategoryModel.fromJson(json)).toList();
      return Right(categories);
    } else {
      return Left('Failed to load categories: ${response.statusCode}');
    }
  }

  // Update table status
  Future<Either<String, TableModel>> updateStatus({
    required int tableId,
    required String status,
    String? customerName,
    String? customerPhone,
    int? partySize,
  }) async {
    final headers = await ApiHelper.getHeaders();
    
    final Map<String, dynamic> body = {
      'status': status,
    };

    if (customerName != null && customerName.isNotEmpty) {
      body['customer_name'] = customerName;
    }
    if (customerPhone != null && customerPhone.isNotEmpty) {
      body['customer_phone'] = customerPhone;
    }
    if (partySize != null) {
      body['party_size'] = partySize;
    }

    final response = await http.put(
      Uri.parse('${Variables.baseUrl}/api/tables/$tableId/status'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final table = TableModel.fromJson(jsonResponse['data']);
      return Right(table);
    } else {
      return Left('Failed to update table status: ${response.statusCode}');
    }
  }

  // Get table detail
  Future<Either<String, TableModel>> getTableDetail(int tableId) async {
    final headers = await ApiHelper.getHeaders();
    
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/tables/$tableId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final table = TableModel.fromJson(jsonResponse['data']);
      return Right(table);
    } else {
      return Left('Failed to load table detail: ${response.statusCode}');
    }
  }
}
