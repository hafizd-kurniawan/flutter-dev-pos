import 'package:shared_preferences/shared_preferences.dart';

class NotificationLocalDatasource {
  static const String _keyFcmEnabled = 'fcm_enabled';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyNewOrderAlerts = 'new_order_alerts';
  static const String _keyLowStockAlerts = 'low_stock_alerts';

  Future<bool> isFcmEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFcmEnabled) ?? true;
  }

  Future<void> setFcmEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFcmEnabled, value);
  }

  Future<bool> isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> setSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySoundEnabled, value);
  }

  Future<bool> isNewOrderAlertEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNewOrderAlerts) ?? true;
  }

  Future<void> setNewOrderAlertEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNewOrderAlerts, value);
  }

  Future<bool> isLowStockAlertEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLowStockAlerts) ?? true;
  }

  Future<void> setLowStockAlertEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLowStockAlerts, value);
  }
}
