import 'dart:developer';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/item_sales_response_model.dart';
import 'package:flutter_posresto_app/data/models/response/product_sales_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class OrderItemRemoteDatasource {
  Future<Either<String, ItemSalesResponseModel>> getItemSalesByRangeDate(
    String stratDate,
    String endDate,
  ) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(
            '${Variables.baseUrl}/api/order-item?start_date=$stratDate&end_date=$endDate'),
        headers: headers,
      );
      log("Response: ${response.statusCode}");
      log("Response: ${response.body}");
      if (response.statusCode == 200) {
        return Right(ItemSalesResponseModel.fromJson(response.body));
      } else {
        return const Left("Failed Load Data");
      }
    } catch (e) {
      log("Error: $e");
      return Left("Failed: $e");
    }
  }

  Future<Either<String, ProductSalesResponseModel>> getProductSalesByRangeDate(
    String stratDate,
    String endDate,
  ) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(
            '${Variables.baseUrl}/api/order-sales?start_date=$stratDate&end_date=$endDate'),
        headers: headers,
      );
      log("Response: ${response.statusCode}");
      log("Response: ${response.body}");
      if (response.statusCode == 200) {
        return Right(ProductSalesResponseModel.fromJson(response.body));
      } else {
        return const Left("Failed Load Data");
      }
    } catch (e) {
      log("Error: $e");
      return Left("Failed: $e");
    }
  }
}
