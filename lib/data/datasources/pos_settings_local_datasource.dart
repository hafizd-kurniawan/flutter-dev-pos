import 'package:shared_preferences/shared_preferences.dart';

class PosSettingsLocalDatasource {
  // Keys for storage
  static const String _discountKey = 'selected_discount_id';
  static const String _taxKey = 'selected_tax_id';
  static const String _serviceKey = 'selected_service_id';
  static const String _cashierKey = 'current_cashier_id';

  // ============================================================
  // SAVE SELECTED SETTINGS
  // ============================================================

  /// Save selected discount ID
  Future<void> saveSelectedDiscount(int? discountId) async {
    final prefs = await SharedPreferences.getInstance();
    if (discountId == null) {
      await prefs.remove(_discountKey);
    } else {
      await prefs.setInt(_discountKey, discountId);
    }
  }

  /// Save selected tax ID
  Future<void> saveSelectedTax(int? taxId) async {
    final prefs = await SharedPreferences.getInstance();
    if (taxId == null) {
      await prefs.remove(_taxKey);
    } else {
      await prefs.setInt(_taxKey, taxId);
    }
  }

  /// Save selected service ID
  Future<void> saveSelectedService(int? serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    if (serviceId == null) {
      await prefs.remove(_serviceKey);
    } else {
      await prefs.setInt(_serviceKey, serviceId);
    }
  }

  // ============================================================
  // GET SELECTED SETTINGS
  // ============================================================

  /// Get selected discount ID
  Future<int?> getSelectedDiscountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_discountKey);
  }

  /// Get selected tax ID
  Future<int?> getSelectedTaxId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_taxKey);
  }

  /// Get selected service ID
  Future<int?> getSelectedServiceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_serviceKey);
  }

  // ============================================================
  // CASHIER MANAGEMENT
  // ============================================================

  /// Save current cashier ID
  /// If cashier changes, clear all selections
  Future<void> saveCashierId(int cashierId) async {
    final prefs = await SharedPreferences.getInstance();
    final previousCashierId = prefs.getInt(_cashierKey);

    // If cashier changed, clear all selections
    if (previousCashierId != null && previousCashierId != cashierId) {
      print('🔄 Cashier changed: $previousCashierId → $cashierId');
      print('   Clearing all selections...');
      await clearSelections();
    }

    await prefs.setInt(_cashierKey, cashierId);
  }

  /// Get current cashier ID
  Future<int?> getCurrentCashierId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cashierKey);
  }

  /// Clear all selections (discount, tax, service)
  Future<void> clearSelections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_discountKey);
    await prefs.remove(_taxKey);
    await prefs.remove(_serviceKey);
    print('✅ All selections cleared');
  }

  /// Clear everything including cashier
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_discountKey);
    await prefs.remove(_taxKey);
    await prefs.remove(_serviceKey);
    await prefs.remove(_cashierKey);
    print('✅ All POS settings data cleared');
  }
}
