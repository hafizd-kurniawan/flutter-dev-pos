import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:flutter_posresto_app/data/models/response/dashboard_summary_model.dart';
import 'package:http/http.dart' as http;

class DashboardRemoteDatasource {
  Future<Either<String, DashboardSummaryResponse>> getTodaySummary() async {
    try {
      final url = Uri.parse('${Variables.baseUrl}/api/dashboard/today-summary');
      final headers = await ApiHelper.getHeaders();
      
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Right(DashboardSummaryResponse.fromJson(jsonResponse));
      } else {
        return Left('Failed to load dashboard summary: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error: ${e.toString()}');
    }
  }
}
