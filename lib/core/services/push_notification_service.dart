import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/track_order/data/model/notification_model.dart';

@visibleForTesting
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}

typedef TokenProvider = Future<String> Function();

@singleton
class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FirebaseFirestore _firestore;
  final http.Client _client;
  TokenProvider? tokenProvider; // 👈 أضيفي هذا

  PushNotificationService(
    this._firebaseMessaging,
    this._localNotifications,
    this._firestore,
    this._client,
  );

  String? _deviceToken;
  String? get deviceToken => _deviceToken;

  final StreamController<void> _notificationStreamController =
      StreamController.broadcast();
  Stream<void> get onNotificationReceived =>
      _notificationStreamController.stream;

  Future<void> init() async {
    await requestPermission();
    await initLocalNotifications();
    await getDeviceToken();

    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }

    FirebaseMessaging.onMessage.listen(handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessageOpenedApp);
  }

  void handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      showLocalNotification(message);
      _notificationStreamController.add(null);
    }
  }

  void handleMessageOpenedApp(RemoteMessage message) {
    _notificationStreamController.add(null);
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  Future<void> getDeviceToken() async {
    try {
      if (Platform.isIOS) {
        _deviceToken = await _firebaseMessaging.getAPNSToken();
      } else {
        _deviceToken = await _firebaseMessaging.getToken();
      }
    } catch (e) {
      _deviceToken = null;
      if (kDebugMode) print('Error getting device token: $e');
    }
  }

  Future<void> initLocalNotifications() async {
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

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      String accessToken;
      String projectId = "tracking-app-123";

      // 👈 الاستخدام هنا بنفس المنطق
      if (tokenProvider != null) {
        accessToken = await tokenProvider!();
      } else {
        final String response = await rootBundle.loadString(
          'assets/json/tracking-app-service.json',
        );
        final serviceAccountJson = json.decode(response);
        final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
        projectId = serviceAccountJson['project_id'];

        final authClient = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
        );
        accessToken = authClient.credentials.accessToken.data;
        authClient.close();
      }

      // بقية الكود الآن سيتم تغطيته بالكامل لأننا تخطينا الـ Exception
      final http.Response httpResponse = await _client.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
        ),
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

      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
        // السطور دي هي اللي كانت "حمراء" ودلوقتي هتبقى "خضراء"
        final newNotification = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          receiverId: data?['userId'] ?? 'unknown',
          title: title,
          body: body,
          sentAt: DateTime.now(),
          isRead: false,
          metadata: data,
        );
        await saveNotification(newNotification);
      }
    } catch (e) {
      if (kDebugMode) print("❌ Notification Service Error: $e");
    }
  }

  Future<void> saveNotification(NotificationModel notification) async {
    await _firestore
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toJson());
  }
}
