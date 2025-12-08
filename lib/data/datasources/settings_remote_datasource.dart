import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:flutter_posresto_app/data/models/response/settings_response_model.dart';
import 'package:http/http.dart' as http;

class SettingsRemoteDatasource {
  Future<Either<String, SettingsResponseModel>> getSettings() async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/settings'),
        headers: headers,
      );

      print('🔌 Settings API Request: ${Variables.baseUrl}/api/settings');
      print('🔌 Response Code: ${response.statusCode}');
      print('🔌 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return Right(SettingsResponseModel.fromJson(response.body));
      } else {
        return Left('Server Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Settings API Exception: $e');
      return Left(e.toString());
    }
  }
}
