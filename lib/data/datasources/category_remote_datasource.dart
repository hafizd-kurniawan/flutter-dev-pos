import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/category_response_model.dart';
import 'package:http/http.dart' as http;

class CategoryRemoteDatasource {
  Future<Either<String, CategroyResponseModel>> getCategories() async {
    final headers = await ApiHelper.getHeaders();
    final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/categories'),
        headers: headers);
    log('Categories API Status: ${response.statusCode}');
    log('Categories Response: ${response.body}');
    if (response.statusCode == 200) {
      return right(CategroyResponseModel.fromJson(response.body));
    } else {
      return left('Failed to get categories: ${response.statusCode}');
    }
  }
}
