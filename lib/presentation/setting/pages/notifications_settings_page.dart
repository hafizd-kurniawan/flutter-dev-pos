import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/services/notification_service.dart';

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
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _testNotification() async {
    // Show a real local notification using NotificationService
    try {
      await NotificationService.showTestNotification();
      
      // Also show snackbar for confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Test notification sent! Check your notification tray.'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage how you receive notifications',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // FCM Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NotificationService.isInitialized() 
                    ? Colors.green.shade50 
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: NotificationService.isInitialized() 
                      ? Colors.green.shade200 
                      : Colors.orange.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        NotificationService.isInitialized() 
                            ? Icons.check_circle 
                            : Icons.warning,
                        color: NotificationService.isInitialized() 
                            ? Colors.green.shade700 
                            : Colors.orange.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          NotificationService.isInitialized()
                              ? 'FCM Service Active'
                              : 'FCM Service Not Initialized',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: NotificationService.isInitialized() 
                                ? Colors.green.shade900 
                                : Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (NotificationService.getFcmToken() != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Token: ${NotificationService.getFcmToken()!.substring(0, 20)}...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                  if (!NotificationService.isInitialized()) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Configure Firebase to enable push notifications',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // FCM Enabled Card
            _buildSettingCard(
              icon: Icons.cloud,
              title: 'Push Notifications',
              subtitle: 'Enable or disable all push notifications',
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
              title: 'Notification Sound',
              subtitle: 'Play sound when notifications arrive',
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // New Order Alerts Card
            _buildSettingCard(
              icon: Icons.shopping_cart,
              title: 'New Order Alerts',
              subtitle: 'Get notified when new orders arrive',
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
              title: 'Low Stock Alerts',
              subtitle: 'Get notified when products are running low',
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
                label: const Text('Test Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifications help you stay updated with orders and inventory. You can customize your preferences anytime.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                borderRadius: BorderRadius.circular(8),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
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
