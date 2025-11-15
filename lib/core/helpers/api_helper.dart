import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';

class ApiHelper {
  /// Get headers for API requests with authentication and tenant
  static Future<Map<String, String>> getHeaders() async {
    final authData = await AuthLocalDataSource().getAuthData();
    final tenant = await AuthLocalDataSource().getTenantSubdomain();
    
    return {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Tenant': tenant, // CRITICAL for multi-tenancy!
    };
  }
  
  /// Get headers without authentication (for public endpoints)
  static Map<String, String> getPublicHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
}
