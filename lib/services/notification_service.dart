import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling background message: ${message.messageId}');
  log('Background notification: ${message.notification?.title}');
}

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static String? _fcmToken;
  static bool _initialized = false;

  // Navigation callback
  static Function(String, String)? onNotificationTap;

  /// Initialize notification service
  static Future<void> init() async {
    if (_initialized) return;

    try {
      log('🔔 Initializing Notification Service...');

      // Request permission
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        criticalAlert: false,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('✅ User granted notification permission');

        // Get FCM token
        _fcmToken = await _fcm.getToken();
        log('📱 FCM Token: $_fcmToken');

        // Save token to local storage temporarily
        if (_fcmToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('fcm_token', _fcmToken!);
          log('💾 FCM token saved to local storage');

          // Send to backend API
          await _saveFcmTokenToBackend(_fcmToken!);
        }

        // Initialize local notifications
        await _initLocalNotifications();

        // Setup message handlers
        _setupMessageHandlers();

        // Listen for token refresh
        _fcm.onTokenRefresh.listen((newToken) {
          log('🔄 FCM Token refreshed: $newToken');
          _fcmToken = newToken;
          // Update backend
          _saveFcmTokenToBackend(newToken);
        });

        _initialized = true;
        log('✅ Notification Service initialized successfully');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log('⚠️ User granted provisional notification permission');
        _initialized = true;
      } else {
        log('❌ User declined notification permission');
      }
    } catch (e) {
      log('❌ Error initializing notification service: $e');
    }
  }

  /// Initialize local notifications (for foreground display)
  static Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    log('✅ Local notifications initialized');
  }

  /// Setup FCM message handlers
  static void _setupMessageHandlers() {
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler);

    // Foreground messages (app is open)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages (app in background, user taps notification)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Terminated state (app was closed, user taps notification to open)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        log('🚀 App opened from terminated state via notification');
        _handleNotificationTap(message);
      }
    });

    log('✅ Message handlers setup complete');
  }

  /// Handle foreground message (show local notification)
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    log('📨 Foreground message received: ${message.messageId}');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
    log('Data: ${message.data}');

    // Check user preferences
    final prefs = await SharedPreferences.getInstance();
    final fcmEnabled = prefs.getBool('fcm_enabled') ?? true;

    if (!fcmEnabled) {
      log('🔕 Notifications disabled by user');
      return;
    }

    // Check notification type preference
    final notificationType = message.data['type'] ?? '';
    if (!await _isNotificationTypeEnabled(notificationType)) {
      log('🔕 ${notificationType} notifications disabled by user');
      return;
    }

    // Show local notification
    await _showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: _encodePayload(message.data),
      notificationType: notificationType,
    );

    log('✅ Local notification shown');
  }

  /// Show local notification
  static Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required String notificationType,
  }) async {
    // Notification channel based on type
    AndroidNotificationDetails androidDetails;

    if (notificationType == 'new_order') {
      androidDetails = AndroidNotificationDetails(
        'new_orders',
        'New Orders',
        channelDescription: 'Notifications for new orders',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        color: Color(0xFF6750A4),
        icon: '@mipmap/ic_launcher',
        ticker: 'New Order Received',
      );
    } else if (notificationType == 'low_stock') {
      androidDetails = AndroidNotificationDetails(
        'low_stock',
        'Low Stock Alerts',
        channelDescription: 'Alerts when products are low in stock',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: true,
        color: Color(0xFFFF9800),
        icon: '@mipmap/ic_launcher',
      );
    } else {
      androidDetails = AndroidNotificationDetails(
        'general',
        'General Notifications',
        channelDescription: 'General app notifications',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      );
    }

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Check if notification type is enabled
  static Future<bool> _isNotificationTypeEnabled(String type) async {
    final prefs = await SharedPreferences.getInstance();

    switch (type) {
      case 'new_order':
        return prefs.getBool('new_order_alerts') ?? true;
      case 'low_stock':
        return prefs.getBool('low_stock_alerts') ?? true;
      default:
        return true;
    }
  }

  /// Handle notification tap from FCM (background/terminated state)
  static void _handleNotificationTap(RemoteMessage message) {
    log('👆 Notification tapped: ${message.messageId}');

    final type = message.data['type'] ?? '';
    final id = message.data['id'] ?? '';

    log('Type: $type, ID: $id');

    // Call navigation callback if set
    if (onNotificationTap != null) {
      onNotificationTap!(type, id);
    }
  }

  /// Handle local notification tap (foreground state)
  static void _onLocalNotificationTap(NotificationResponse response) {
    log('👆 Local notification tapped');

    if (response.payload != null) {
      final data = _decodePayload(response.payload!);
      final type = data['type'] ?? '';
      final id = data['id'] ?? '';

      log('Type: $type, ID: $id');

      // Call navigation callback if set
      if (onNotificationTap != null) {
        onNotificationTap!(type, id);
      }
    }
  }

  /// Encode payload to string
  static String _encodePayload(Map<String, dynamic> data) {
    return data.entries.map((e) => '${e.key}:${e.value}').join('|');
  }

  /// Decode payload from string
  static Map<String, String> _decodePayload(String payload) {
    final map = <String, String>{};
    for (var pair in payload.split('|')) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    }
    return map;
  }

  /// Get FCM token
  static String? getFcmToken() => _fcmToken;

  /// Check if initialized
  static bool isInitialized() => _initialized;

  /// Refresh FCM token
  static Future<void> refreshToken() async {
    try {
      await _fcm.deleteToken();
      _fcmToken = await _fcm.getToken();
      log('🔄 FCM Token refreshed: $_fcmToken');

      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
        // TODO: Update backend
        // await _saveFcmTokenToBackend(_fcmToken!);
      }
    } catch (e) {
      log('❌ Error refreshing token: $e');
    }
  }

  /// Show test notification (for testing)
  static Future<void> showTestNotification() async {
    await _showLocalNotification(
      id: 999999,
      title: '🧪 Test Notification',
      body: 'This is a test notification from NotificationService',
      payload: 'type:test|id:999',
      notificationType: 'test',
    );
    log('✅ Test notification shown');
  }

  /// Save FCM token to backend API
  static Future<void> _saveFcmTokenToBackend(String token) async {
    try {
      final authData = await AuthLocalDataSource().getAuthData();
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/fcm-token'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'fcm_token': token}),
      );
      
      if (response.statusCode == 200) {
        log('✅ FCM token saved to backend');
      } else {
        log('❌ Failed to save FCM token: ${response.statusCode}');
        log('Response body: ${response.body}');
      }
    } catch (e) {
      log('❌ Error saving FCM token to backend: $e');
    }
  }
}
