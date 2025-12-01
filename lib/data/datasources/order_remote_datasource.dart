import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/order_report_response_model.dart';
import 'package:flutter_posresto_app/data/models/response/order_response_model.dart';
import 'package:flutter_posresto_app/data/models/response/summary_response_model.dart';
import 'package:flutter_posresto_app/presentation/home/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDatasource {
  //save order to remote server
  Future<bool> saveOrder(OrderModel orderModel) async {
    final headers = await ApiHelper.getHeaders();
    // Fetch current user for cashier name
    final authData = await AuthLocalDataSource().getAuthData();
    final cashierName = authData?.user?.name ?? 'Unknown Cashier';
    
    final orderMap = orderModel.toServerMap();
    orderMap['cashier_name'] = cashierName; // NEW: Add cashier name
    
    log("📤 Sending Order to API...");
    log("Order Data: $orderMap");
    
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/save-order'),
      body: jsonEncode(orderMap), // Encode the modified map
      headers: headers,
    );
    
    log("🚀 DEBUG PAYLOAD: ${jsonEncode(orderMap)}"); // NEW: Log exact payload
    log("📝 Note in Payload: ${orderMap['notes']}"); // NEW: Log specific note field
    
    log("📥 Response Status: ${response.statusCode}");
    log("📥 Response Body: ${response.body}");
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("✅ Order saved successfully!");
      return true;
    } else {
      log("❌ Failed to save order: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  Future<Either<String, OrderReportResponseModel>> getOrderByRangeDate(
    String stratDate,
    String endDate,
  ) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(
            '${Variables.baseUrl}/api/orders?start_date=$stratDate&end_date=$endDate'),
        headers: headers,
      );
      log("Response: ${response.statusCode}");
      log("Response: ${response.body}");
      if (response.statusCode == 200) {
        return Right(OrderReportResponseModel.fromJson(response.body));
      } else {
        return const Left("Failed Load Data");
      }
    } catch (e) {
      log("Error: $e");
      return Left("Failed: $e");
    }
  }

  Future<Either<String, SummaryResponseModel>> getSummaryByRangeDate(
    String stratDate,
    String endDate,
  ) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(
            '${Variables.baseUrl}/api/summary?start_date=$stratDate&end_date=$endDate'),
        headers: headers,
      );
      log("Url: ${response.request!.url}");
      log("Response: ${response.statusCode}");

      log("Response: ${response.body}");
      if (response.statusCode == 200) {
        return Right(SummaryResponseModel.fromJson(response.body));
      } else {
        return const Left("Failed Load Data");
      }
    } catch (e) {
      log("Error: $e");
      return Left("Failed: $e");
    }
  }

  // Get paid orders (new orders)
  Future<Either<String, List<OrderResponseModel>>> getPaidOrders() async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/orders/paid'),
        headers: headers,
      );
      
      log("📡 GET Paid Orders - Status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final ordersResponse = OrdersListResponseModel.fromJson(response.body);
        log("✅ Loaded ${ordersResponse.data.length} paid orders");
        return Right(ordersResponse.data);
      } else {
        log("❌ Failed to load paid orders: ${response.body}");
        return const Left("Failed to load paid orders");
      }
    } catch (e) {
      log("❌ Error loading paid orders: $e");
      return Left("Error: $e");
    }
  }

  // Get cooking orders
  Future<Either<String, List<OrderResponseModel>>> getCookingOrders() async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/orders/cooking'),
        headers: headers,
      );
      
      log("📡 GET Cooking Orders - Status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final ordersResponse = OrdersListResponseModel.fromJson(response.body);
        log("✅ Loaded ${ordersResponse.data.length} cooking orders");
        return Right(ordersResponse.data);
      } else {
        log("❌ Failed to load cooking orders: ${response.body}");
        return const Left("Failed to load cooking orders");
      }
    } catch (e) {
      log("❌ Error loading cooking orders: $e");
      return Left("Error: $e");
    }
  }

  // Get completed orders
  Future<Either<String, List<OrderResponseModel>>> getCompletedOrders() async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/orders/completed'),
        headers: headers,
      );
      
      log("📡 GET Completed Orders - Status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final ordersResponse = OrdersListResponseModel.fromJson(response.body);
        log("✅ Loaded ${ordersResponse.data.length} completed orders");
        return Right(ordersResponse.data);
      } else {
        log("❌ Failed to load completed orders: ${response.body}");
        return const Left("Failed to load completed orders");
      }
    } catch (e) {
      log("❌ Error loading completed orders: $e");
      return Left("Error: $e");
    }
  }

  // Update order status
  Future<Either<String, bool>> updateOrderStatus(int orderId, String status) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.put(
        Uri.parse('${Variables.baseUrl}/api/orders/$orderId/status'),
        headers: headers,
        body: jsonEncode({'status': status}), // Convert Map to JSON string
      );
      
      log("📡 UPDATE Order Status - ID: $orderId, Status: $status");
      log("📡 Response: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        log("✅ Order status updated successfully");
        return const Right(true);
      } else {
        log("❌ Failed to update order status: ${response.body}");
        return const Left("Failed to update order status");
      }
    } catch (e) {
      log("❌ Error updating order status: $e");
      return Left("Error: $e");
    }
  }
}
