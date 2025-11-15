import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/data/models/response/pos_settings_model.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:http/http.dart' as http;

class PosSettingsRemoteDatasource {
  /// Get POS settings (discounts, taxes, services)
  /// Returns only active items
  Future<Either<String, PosSettingsModel>> getSettings() async {
    final url = Uri.parse('${Variables.baseUrl}/api/pos-settings');
    
    // Get headers with auth token
    final headers = await ApiHelper.getHeaders();
    
    try {
      print('🔧 Fetching POS settings from: $url');
      
      final response = await http.get(url, headers: headers);
      
      print('📡 POS Settings Response Status: ${response.statusCode}');
      print('📡 POS Settings Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Check if success
        if (data['success'] == true) {
          final settingsData = data['data'];
          final settings = PosSettingsModel.fromMap(settingsData);
          
          print('✅ POS Settings loaded:');
          print('   Discounts: ${settings.discounts.length}');
          print('   Taxes: ${settings.taxes.length}');
          print('   Services: ${settings.services.length}');
          
          return Right(settings);
        } else {
          final message = data['message'] ?? 'Failed to get settings';
          return Left(message);
        }
      } else if (response.statusCode == 401) {
        return const Left('Unauthorized. Please login again.');
      } else {
        return Left('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching POS settings: $e');
      return Left('Network error: $e');
    }
  }
}
