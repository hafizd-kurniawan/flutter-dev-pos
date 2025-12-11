import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _fcmEnabled = true;
  bool _soundEnabled = true;
  bool _newOrderAlerts = true;
  bool _lowStockAlerts = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _fcmEnabled = prefs.getBool('fcm_enabled') ?? true;
        _soundEnabled = prefs.getBool('sound_enabled') ?? true;
        _newOrderAlerts = prefs.getBool('new_order_alerts') ?? true;
        _lowStockAlerts = prefs.getBool('low_stock_alerts') ?? true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar('Failed to load settings');
    }
  }

  Future<void> _saveSetting(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
      _showSuccessSnackbar('Settings saved');
    } catch (e) {
      _showErrorSnackbar('Failed to save settings');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.quicksand()),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.quicksand()),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _testNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.test_notification,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  ),
                  Text(AppLocalizations.of(context)!.notification_preview, style: GoogleFonts.quicksand()),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.ok,
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(0), // Padding is handled by parent container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title (Only for Mobile if needed, but usually redundant with Header)
          // We'll keep a section title
          Text(
            'Notification Preferences',
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage how you receive notifications',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // FCM Enabled Card
          _buildSettingCard(
            icon: Icons.cloud,
            title: AppLocalizations.of(context)!.push_notifications,
            subtitle: AppLocalizations.of(context)!.push_notifications_desc,
            value: _fcmEnabled,
            onChanged: (value) {
              setState(() {
                _fcmEnabled = value;
              });
              _saveSetting('fcm_enabled', value);
            },
          ),

          const SizedBox(height: 16),

          // Sound Enabled Card
          _buildSettingCard(
            icon: Icons.volume_up,
            title: AppLocalizations.of(context)!.notification_sound,
            subtitle: AppLocalizations.of(context)!.notification_sound_desc,
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
              _saveSetting('sound_enabled', value);
            },
          ),

          const SizedBox(height: 32),

          // Section Header
          Text(
            'Alert Types',
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          // New Order Alerts Card
          _buildSettingCard(
            icon: Icons.shopping_cart,
            title: AppLocalizations.of(context)!.new_order_alerts,
            subtitle: AppLocalizations.of(context)!.new_order_alerts_desc,
            value: _newOrderAlerts,
            onChanged: (value) {
              setState(() {
                _newOrderAlerts = value;
              });
              _saveSetting('new_order_alerts', value);
            },
          ),

          const SizedBox(height: 16),

          // Low Stock Alerts Card
          _buildSettingCard(
            icon: Icons.inventory_2,
            title: AppLocalizations.of(context)!.low_stock_alerts,
            subtitle: AppLocalizations.of(context)!.low_stock_alerts_desc,
            value: _lowStockAlerts,
            onChanged: (value) {
              setState(() {
                _lowStockAlerts = value;
              });
              _saveSetting('low_stock_alerts', value);
            },
          ),

          const SizedBox(height: 32),

          // Test Notification Button
          Center(
            child: ElevatedButton.icon(
              onPressed: _testNotification,
              icon: const Icon(Icons.notifications_active),
              label: Text(AppLocalizations.of(context)!.test_notification, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Switch
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
