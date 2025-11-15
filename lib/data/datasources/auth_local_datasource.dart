import 'package:flutter_posresto_app/data/models/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', authResponseModel.toJson());
    // Save tenant subdomain separately for easy access
    if (authResponseModel.tenant?.subdomain != null) {
      await prefs.setString('tenant_subdomain', authResponseModel.tenant!.subdomain!);
    }
  }

  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
    await prefs.remove('tenant_subdomain');
  }
  
  Future<String> getTenantSubdomain() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tenant_subdomain') ?? '';
  }

  Future<AuthResponseModel> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');

    return AuthResponseModel.fromJson(authData!);
  }

  Future<bool> isAuthDataExists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_data');
  }

  Future<void> saveMidtransServerKey(String serverKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_key', serverKey);
  }

  //get midtrans server key
  Future<String> getMitransServerKey() async {
    final prefs = await SharedPreferences.getInstance();
    final serverKey = prefs.getString('server_key');
    return serverKey ?? '';
  }

  // save size receipt
  Future<void> saveSizeReceipt(String sizeReceipt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('size_receipt', sizeReceipt);
  }

  // get size receipt
  Future<String> getSizeReceipt() async {
    final prefs = await SharedPreferences.getInstance();
    final sizeReceipt = prefs.getString('size_receipt');
    return sizeReceipt ?? '';
  }
}
