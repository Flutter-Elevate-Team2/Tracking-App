import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/services/push_notification_service.dart';

@GenerateMocks([
  FirebaseMessaging,
  FlutterLocalNotificationsPlugin,
  NotificationSettings,
])
import 'push_notification_service_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PushNotificationService service;
  late MockFirebaseMessaging mockMessaging;
  late MockFlutterLocalNotificationsPlugin mockLocalNotifications;
  late MockNotificationSettings mockSettings;

  setUp(() {
    mockMessaging = MockFirebaseMessaging();
    mockLocalNotifications = MockFlutterLocalNotificationsPlugin();
    mockSettings = MockNotificationSettings();

    when(
      mockMessaging.requestPermission(
        alert: anyNamed('alert'),
        badge: anyNamed('badge'),
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

    service = PushNotificationService(mockMessaging, mockLocalNotifications);
  });

  group('PushNotificationService Clean Coverage Tests', () {
    test('init() and Permission coverage', () async {
      // Act
      await service.init();
      await service.requestPermission();

      // Assert
      verify(
        mockMessaging.requestPermission(alert: true, badge: true, sound: true),
      ).called(2);
      expect(service.deviceToken, 'fake_token');
    });

    test('getDeviceToken covers Android, iOS, and Error paths', () async {
      when(mockMessaging.getToken()).thenAnswer((_) async => 'android_token');
      await service.getDeviceToken();
      expect(service.deviceToken, 'android_token');

      when(mockMessaging.getAPNSToken()).thenAnswer((_) async => 'ios_token');
      await service.getDeviceToken();
      service = PushNotificationService(mockMessaging, mockLocalNotifications);

      when(mockMessaging.getToken()).thenThrow(Exception('Token Error'));
      when(mockMessaging.getAPNSToken()).thenThrow(Exception('Token Error'));

      await service.getDeviceToken();

      expect(service.deviceToken, isNull);
    });

    test('showLocalNotification success and null guard coverage', () async {
      final message = RemoteMessage(
        notification: const RemoteNotification(
          title: 'Order Update',
          body: 'Your order is on the way',
          android: AndroidNotification(),
        ),
        data: {'orderId': '123'},
      );

      await service.showLocalNotification(message);
      verify(
        mockLocalNotifications.show(
          any,
          'Order Update',
          'Your order is on the way',
          any,
          payload: anyNamed('payload'),
        ),
      ).called(1);

      await service.showLocalNotification(
        const RemoteMessage(notification: null),
      );
      verifyNoMoreInteractions(mockLocalNotifications);
    });

    test('sendNotification covers asset loading and error catch', () async {
      final serviceAccountMock = {
        'project_id': 'test-123',
        'private_key': 'mock_key',
        'client_email': 'mock@test.com',
      };

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            message,
          ) async {
            final data = utf8.encode(json.encode(serviceAccountMock));
            return ByteData.view(Uint8List.fromList(data).buffer);
          });

      await service.sendNotification(token: 'token', title: 'T', body: 'B');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('flutter/assets'),
            (message) async => null,
          );

      await service.sendNotification(token: 'token', title: 'T', body: 'B');
    });

    test('Stream and helper initialization coverage', () async {
      expect(service.onNotificationReceived, isA<Stream<void>>());

      await service.initLocalNotifications();
      verify(
        mockLocalNotifications.initialize(
          any,
          onDidReceiveNotificationResponse: anyNamed(
            'onDidReceiveNotificationResponse',
          ),
        ),
      ).called(1);
    });

    test('Force coverage for Notification Listeners', () async {
      final message = RemoteMessage(
        notification: const RemoteNotification(
          title: 'T',
          body: 'B',
          android: AndroidNotification(),
        ),
      );

      service.handleForegroundMessage(message);
      service.handleMessageOpenedApp(message);

      // Assert
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

    test('showLocalNotification - branch coverage (android is null)', () async {
      final message = RemoteMessage(
        notification: const RemoteNotification(
          title: 'T',
          body: 'B',
          android: null,
        ),
      );
      await service.showLocalNotification(message);
    });

    test('showLocalNotification - full branch coverage', () async {
      final messageNoAndroid = RemoteMessage(
        notification: const RemoteNotification(
          title: 'T',
          body: 'B',
          android: null,
        ),
      );
      await service.showLocalNotification(messageNoAndroid);

      await service.showLocalNotification(
        const RemoteMessage(notification: null),
      );
    });

    test('handleForegroundMessage - notification is null', () async {
      const message = RemoteMessage(notification: null);
      service.handleForegroundMessage(message);
    });
  });
}
