import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDatasource {
  static const String _appNameKey = 'setting_app_name';
  static const String _addressKey = 'setting_restaurant_address';
  static const String _phoneKey = 'setting_restaurant_phone';
  static const String _footerKey = 'setting_receipt_footer';

  Future<void> saveSettings(Map<String, String> settings) async {
    final prefs = await SharedPreferences.getInstance();
    if (settings.containsKey('app_name')) {
      await prefs.setString(_appNameKey, settings['app_name']!);
      print('💾 Saved app_name: ${settings['app_name']}'); // DEBUG LOG
    }
    if (settings.containsKey('restaurant_address')) {
      await prefs.setString(_addressKey, settings['restaurant_address']!);
      print('💾 Saved restaurant_address: ${settings['restaurant_address']}'); // DEBUG LOG
    }
    if (settings.containsKey('restaurant_phone')) {
      await prefs.setString(_phoneKey, settings['restaurant_phone']!);
      print('💾 Saved restaurant_phone: ${settings['restaurant_phone']}'); // DEBUG LOG
    }
    if (settings.containsKey('receipt_footer_text')) {
      await prefs.setString(_footerKey, settings['receipt_footer_text']!);
      print('💾 Saved receipt_footer_text: ${settings['receipt_footer_text']}'); // DEBUG LOG
    }
  }

  Future<Map<String, String>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settings = {
      'app_name': prefs.getString(_appNameKey) ?? 'Self Order POS',
      'restaurant_address': prefs.getString(_addressKey) ?? 'Jl. Raya No. 123, Jakarta',
      'restaurant_phone': prefs.getString(_phoneKey) ?? '',
      'receipt_footer_text': prefs.getString(_footerKey) ?? 'Terima Kasih',
    };
    print('📂 Loaded Settings: $settings'); // DEBUG LOG
    return settings;
  }
}
