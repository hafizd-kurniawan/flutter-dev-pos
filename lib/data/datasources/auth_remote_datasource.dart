import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/auth_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      String email, String password) async {
    final url = Uri.parse('${Variables.baseUrl}/api/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to login');
    }
  }

  // Register
  Future<Either<String, AuthResponseModel>> register(
    String businessName,
    String email,
    String phone,
    String address,
    String password,
  ) async {
    final url = Uri.parse('${Variables.baseUrl}/api/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'business_name': businessName,
        'email': email,
        'phone': phone,
        'address': address,
        'password': password,
        'password_confirmation': password,
      }),
    );

    if (response.statusCode == 201) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      final body = jsonDecode(response.body);
      return Left(body['message'] ?? 'Failed to register');
    }
  }

  //logout
  Future<Either<String, bool>> logout() async {
    final headers = await ApiHelper.getHeaders();
    final url = Uri.parse('${Variables.baseUrl}/api/logout');
    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left('Failed to logout');
    }
  }

  // Update FCM Token
  Future<Either<String, bool>> updateFcmToken(String token) async {
    final headers = await ApiHelper.getHeaders();
    final url = Uri.parse('${Variables.baseUrl}/api/fcm-token');
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'fcm_token': token}),
    );

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left('Failed to update FCM token');
    }
  }
}
