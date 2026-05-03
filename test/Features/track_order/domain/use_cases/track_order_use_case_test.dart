import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/track_order_use_case.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';

import 'get_order_details_use_case_test.mocks.dart';
@GenerateMocks([FirebaseOrderService])

void main() {
  late UpdateOrderStatusUseCase useCase;
  late MockFirebaseOrderService mockFirebaseService;

  setUp(() {
    mockFirebaseService = MockFirebaseOrderService();
    useCase = UpdateOrderStatusUseCase(mockFirebaseService);
  });

  const tOrderId = 'order_123';
  const tUserToken = 'token_abc';
  final tStatus = OrderStatus.arrivedUser;
  const tTitle = 'Order Update';
  const tBody = 'Your order is on the way!';

  group('UpdateOrderStatusUseCase Unit Test', () {
    test('should call uploadTrackingOrder with correct data', () async {
      // Arrange
      when(mockFirebaseService.uploadTrackingOrder(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase.call(
        orderId: tOrderId,
        status: tStatus,
        userToken: tUserToken,
        title: tTitle,
        body: tBody,
      );

      // Assert
       verify(mockFirebaseService.uploadTrackingOrder(
        tOrderId,
        argThat(containsPair('status', tStatus.firebaseValue)),
      )).called(1);
    });

    test('should handle empty userToken without crashing (no notification sent)', () async {
      // Arrange
      when(mockFirebaseService.uploadTrackingOrder(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase.call(
        orderId: tOrderId,
        status: tStatus,
        userToken: '',
        title: tTitle,
        body: tBody,
      );

      // Assert
       verify(mockFirebaseService.uploadTrackingOrder(any, any)).called(1);
     });

    test('should throw exception if firebase service fails', () async {
      // Arrange
      when(mockFirebaseService.uploadTrackingOrder(any, any))
          .thenThrow(Exception('Firebase Error'));

      // Act & Assert
      expect(
            () => useCase.call(
          orderId: tOrderId,
          status: tStatus,
          userToken: tUserToken,
          title: tTitle,
          body: tBody,
        ),
        throwsException,
      );
    });
  });
}