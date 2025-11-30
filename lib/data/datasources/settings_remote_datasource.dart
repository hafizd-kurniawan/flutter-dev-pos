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

      if (response.statusCode == 200) {
        print('✅ Settings API Response: ${response.body}'); // DEBUG LOG
        return Right(SettingsResponseModel.fromJson(response.body));
      } else {
        print('❌ Settings API Error: ${response.statusCode} - ${response.body}'); // DEBUG LOG
        return Left('Failed to load settings: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error: $e');
    }
  }
}
