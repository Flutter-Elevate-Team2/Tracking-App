import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/track_order_use_case.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/push_notification_service.dart';

import 'track_order_use_case_test.mocks.dart';

@GenerateMocks([FirebaseOrderService, PushNotificationService])
void main() {
  late UpdateOrderStatusUseCase useCase;
  late MockFirebaseOrderService mockFirebaseService;
  late MockPushNotificationService mockPushService;

  setUp(() {
    mockFirebaseService = MockFirebaseOrderService();
    mockPushService = MockPushNotificationService();
    useCase = UpdateOrderStatusUseCase(mockFirebaseService, mockPushService);
  });

  const tOrderId = 'order_123';
  const tUserToken = 'token_abc';
  final tStatus = OrderStatus.arrivedUser;
  const tTitle = 'Order Update';
  const tBody = 'Your order is on the way!';

  group('UpdateOrderStatusUseCase Unit Test', () {
    test('should call uploadTrackingOrder and sendNotification', () async {
      // Arrange
      when(
        mockFirebaseService.uploadTrackingOrder(any, any),
      ).thenAnswer((_) async => {});
      when(
        mockPushService.sendNotification(
          token: anyNamed('token'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => {});

      // Act
      await useCase.call(
        orderId: tOrderId,
        status: tStatus,
        userToken: tUserToken,
        title: tTitle,
        body: tBody,
        userId: '',
      );

      // Assert
      verify(mockFirebaseService.uploadTrackingOrder(any, any)).called(1);
      verify(
        mockPushService.sendNotification(
          token: tUserToken,
          title: tTitle,
          body: tBody,
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('should NOT call sendNotification when token is empty', () async {
      when(
        mockFirebaseService.uploadTrackingOrder(any, any),
      ).thenAnswer((_) async => {});

      await useCase.call(
        orderId: tOrderId,
        status: tStatus,
        userToken: '',
        title: tTitle,
        body: tBody,
        userId: '',
      );

      verify(mockFirebaseService.uploadTrackingOrder(any, any)).called(1);
      verifyNever(
        mockPushService.sendNotification(
          token: anyNamed('token'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          data: anyNamed('data'),
        ),
      );
    });

    test('should throw exception when firebase upload fails', () async {
      when(
        mockFirebaseService.uploadTrackingOrder(any, any),
      ).thenThrow(Exception('Firebase Error'));

      expect(
        () => useCase.call(
          orderId: tOrderId,
          status: tStatus,
          userToken: tUserToken,
          title: tTitle,
          body: tBody,
          userId: '',
        ),
        throwsException,
      );
    });

    test(
      'should NOT suppress exception when push notification fails',
      () async {
        when(
          mockFirebaseService.uploadTrackingOrder(any, any),
        ).thenAnswer((_) async => {});
        when(
          mockPushService.sendNotification(
            token: anyNamed('token'),
            title: anyNamed('title'),
            body: anyNamed('body'),
            data: anyNamed('data'),
          ),
        ).thenThrow(Exception('Notification Error'));

        expect(
          () => useCase.call(
            orderId: tOrderId,
            status: tStatus,
            userToken: tUserToken,
            title: tTitle,
            body: tBody,
            userId: '',
          ),
          throwsException,
        );
      },
    );
  });
}
