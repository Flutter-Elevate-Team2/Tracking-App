import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static String? _deviceToken;
static Future<String?> getDeviceTokenAsync() async {
  if (_deviceToken != null) {
    return _deviceToken;
  }

  try {
    _deviceToken = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print('Fetched Token on Demand: $_deviceToken');
    }
  } catch (e) {
    if (kDebugMode) {
      print('🚨 Failed to fetch token on demand: $e');
    }
  }

  return _deviceToken;
}
  // StreamController to broadcast notification events
  static final StreamController<void> _notificationStreamController =
      StreamController.broadcast();
  static Stream<void> get onNotificationReceived =>
      _notificationStreamController.stream;

  static Future<void> init() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _getDeviceToken();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print(
            'Message also contained a notification: ${message.notification}',
          );
        }
        _showLocalNotification(message);
        _notificationStreamController.add(null); // Notify listeners
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      _notificationStreamController.add(null); // Notify listeners
      // TODO: Handle navigation here
    });
  }

  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  static Future<void> _getDeviceToken() async {
    try {
      if (Platform.isIOS) {
        _deviceToken = await _firebaseMessaging.getAPNSToken();
      } else {
        _deviceToken = await _firebaseMessaging.getToken();
      }

      if (kDebugMode) {
        print('Device Token: $_deviceToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device token: $e');
      }
    }
  }

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            // Handle notification tap
          },
    );
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  static Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/json/tracking-app-service.json',
      );
      final serviceAccountJson = json.decode(response);

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final authClient = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );

      final String accessToken = authClient.credentials.accessToken.data;
      final String projectId = serviceAccountJson['project_id'];

      final String url =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      final http.Response httpResponse = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {'title': title, 'body': body},
            'data': data ?? {},
          },
        }),
      );

      if (httpResponse.statusCode == 200) {
        if (kDebugMode) print("✅ Notification sent successfully via FCM V1");
      } else {
        if (kDebugMode) {
          print("❌ Error sending notification: ${httpResponse.body}");
        }
      }

      authClient.close();
    } catch (e) {
      if (kDebugMode) print("❌ Notification Service Error: $e");
    }
  }
}
