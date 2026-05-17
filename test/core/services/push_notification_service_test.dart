import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/data/model/notification_model.dart';
import 'package:tracking_app/core/services/firebase_background_handler.dart';
import 'package:tracking_app/core/services/push_notification_service.dart';

import 'push_notification_service_test.mocks.dart';

@GenerateMocks([
  FirebaseMessaging,
  FlutterLocalNotificationsPlugin,
  NotificationSettings,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  http.Client,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PushNotificationService service;
  late MockFirebaseMessaging mockMessaging;
  late MockFlutterLocalNotificationsPlugin mockLocalNotifications;
  late MockNotificationSettings mockSettings;
  late MockFirebaseFirestore mockFirestore;
  late MockClient mockHttpClient;

  setUp(() {
    mockMessaging = MockFirebaseMessaging();
    mockLocalNotifications = MockFlutterLocalNotificationsPlugin();
    mockSettings = MockNotificationSettings();
    mockFirestore = MockFirebaseFirestore();
    mockHttpClient = MockClient();

    when(
      mockMessaging.requestPermission(
        alert: anyNamed('alert'),
        announcement: anyNamed('announcement'),
        badge: anyNamed('badge'),
        carPlay: anyNamed('carPlay'),
        criticalAlert: anyNamed('criticalAlert'),
        provisional: anyNamed('provisional'),
        sound: anyNamed('sound'),
      ),
    ).thenAnswer((_) async => mockSettings);
    when(
      mockSettings.authorizationStatus,
    ).thenReturn(AuthorizationStatus.authorized);
    when(mockMessaging.getToken()).thenAnswer((_) async => 'fake_token');
    when(
      mockLocalNotifications.initialize(
        any,
        onDidReceiveNotificationResponse: anyNamed(
          'onDidReceiveNotificationResponse',
        ),
      ),
    ).thenAnswer((_) async => true);

    service = PushNotificationService(
      mockMessaging,
      mockLocalNotifications,
      mockFirestore,
      mockHttpClient,
    );
    service.tokenProvider = () async => 'fake_access_token';
  });

  group('PushNotificationService Optimized Coverage', () {
    test('init() and getDeviceToken - Full Success/Error Paths', () async {
      // Test init
      await service.init();
      verify(
        mockMessaging.requestPermission(alert: true, badge: true, sound: true),
      ).called(1);

      // Test Android/iOS Token
      when(mockMessaging.getToken()).thenAnswer((_) async => 'android_token');
      await service.getDeviceToken();
      expect(service.deviceToken, 'android_token');

      // Test Exception Path
      when(mockMessaging.getToken()).thenThrow(Exception('Error'));
      await service.getDeviceToken();
      expect(service.deviceToken, isNull);
    });

    test('showLocalNotification - Branch Coverage', () async {
      final message = RemoteMessage(
        notification: const RemoteNotification(
          title: 'T',
          body: 'B',
          android: AndroidNotification(),
        ),
        data: {'id': '1'},
      );
      // Case: Success
      await service.showLocalNotification(message);
      // Case: Null Android or Null Notification
      await service.showLocalNotification(
        const RemoteMessage(
          notification: RemoteNotification(
            title: 'T',
            body: 'B',
            android: null,
          ),
        ),
      );
      await service.showLocalNotification(
        const RemoteMessage(notification: null),
      );

      verify(
        mockLocalNotifications.show(
          any,
          any,
          any,
          any,
          payload: anyNamed('payload'),
        ),
      ).called(1);
    });

    test('sendNotification - Success Case (High Coverage)', () async {
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(json.encode({'name': 'ok'}), 200),
      );

      final mockCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockDoc = MockDocumentReference<Map<String, dynamic>>();

      when(
        mockFirestore.collection('notifications'),
      ).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDoc);
      when(mockDoc.set(any)).thenAnswer((_) async => {});

      // Act
      await service.sendNotification(
        token: 'token',
        title: 'T',
        body: 'B',
        data: {'userId': '123'},
      );

      // Assert
      verify(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).called(1);
      verify(mockFirestore.collection('notifications')).called(1);
      verify(mockDoc.set(any)).called(1);
    });

    test('sendNotification - HTTP Failure & Catch Block Coverage', () async {
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 400));
      await service.sendNotification(token: 't', title: 'T', body: 'B');

      // Case 2: Asset missing (Triggers catch block)
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('flutter/assets'),
            (m) async => null,
          );
      await service.sendNotification(token: 't', title: 'T', body: 'B');

      verifyNever(mockFirestore.collection('notifications'));
    });

    test('saveNotification - Data Validation Coverage', () async {
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockDoc = MockDocumentReference<Map<String, dynamic>>();
      when(
        mockFirestore.collection('notifications'),
      ).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDoc);

      final model = NotificationModel(
        id: '1',
        receiverId: 'u1',
        title: 'T',
        body: 'B',
        sentAt: DateTime.now(),
      );
      await service.saveNotification(model);

      verify(mockDoc.set(argThat(isA<Map<String, dynamic>>()))).called(1);
    });

    test('Listeners and Streams coverage', () async {
      expect(service.onNotificationReceived, isA<Stream<void>>());
      service.handleForegroundMessage(
        const RemoteMessage(
          notification: RemoteNotification(
            title: 'T',
            body: 'B',
            android: AndroidNotification(),
          ),
        ),
      );
      service.handleMessageOpenedApp(const RemoteMessage(notification: null));
    });

    test(
      'sendNotification - should cover catch block on generic exception',
      () async {
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenThrow(Exception('Network Failed'));

        await service.sendNotification(token: 't', title: 'T', body: 'B');

        verifyNever(mockFirestore.collection('notifications'));
      },
    );

    test('Force coverage for Background Handler', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/firebase_core'),
            (message) async => null,
          );

      const message = RemoteMessage(messageId: '123');

      try {
        await firebaseMessagingBackgroundHandler(message);
      } catch (e) {
        debugPrint('Expected background error in test: $e');
      }
    });
  });
}
