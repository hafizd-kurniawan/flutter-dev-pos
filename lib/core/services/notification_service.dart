import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/auth_remote_datasource.dart';

// Background message handler must be top-level
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Make nullable to handle initialization failures
  FirebaseMessaging? _firebaseMessaging;

  Future<void> init() async {
    try {
      // 1. Initialize Firebase
      // Check if Firebase is already initialized to avoid duplicate init errors
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      
      _firebaseMessaging = FirebaseMessaging.instance;

      // 2. Request Permission
      NotificationSettings settings = await _firebaseMessaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted permission');
      } else {
        log('User declined or has not accepted permission');
        return;
      }

      // 3. Set Background Handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 4. Listen to Foreground Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          log('Message also contained a notification: ${message.notification}');
        }
      });

      // 5. Get Token and Sync
      String? token = await _firebaseMessaging!.getToken();
      if (token != null) {
        log("FCM Token: $token");
        await _syncTokenToServer(token);
      }

      // 6. Listen to Token Refresh
      _firebaseMessaging!.onTokenRefresh.listen(_syncTokenToServer);
      
    } catch (e) {
      log("🔥 FCM Initialization Failed: $e");
      // Gracefully fail - do not crash the app
    }
  }

  Future<void> _syncTokenToServer(String token) async {
    // Check if user is logged in
    final isAuth = await AuthLocalDataSource().isAuthDataExists();
    if (isAuth) {
      log("Syncing FCM Token to server...");
      final result = await AuthRemoteDatasource().updateFcmToken(token);
      result.fold(
        (l) => log("Failed to sync FCM token: $l"),
        (r) => log("FCM Token synced successfully"),
      );
    }
  }
}
