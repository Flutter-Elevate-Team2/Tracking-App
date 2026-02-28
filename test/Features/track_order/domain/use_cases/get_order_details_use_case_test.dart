import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_order_details_use_case.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';

@GenerateMocks([FirebaseOrderService])
import 'get_order_details_use_case_test.mocks.dart';

void main() {
  late GetOrderDetailsUseCase useCase;
  late MockFirebaseOrderService mockFirebaseService;

  setUp(() {
    mockFirebaseService = MockFirebaseOrderService();
    useCase = GetOrderDetailsUseCase(mockFirebaseService);
  });

  const tOrderId = '12345';

  group('GetOrderDetailsUseCase Test', () {
    test('should return OrderTrackingEntity when firebase service returns a model', () async {
      // Arrange
      final tFirebaseModel = OrderTrackingFirebaseModel(
        updatedAt: DateTime.now(),
        status: 'delivered',
        orderData: {'orderNumber': tOrderId},
        storeData: {},
        userData: {},
        orderItems: [], driverData: {}, trackingLocation: {},
      );

      when(mockFirebaseService.getTrackingOrderById(any))
          .thenAnswer((_) async => tFirebaseModel);

      // Act
      final result = await useCase.call(tOrderId);

      // Assert
      expect(result, isA<OrderTrackingEntity>());
      expect(result?.orderNumber, tOrderId);
      verify(mockFirebaseService.getTrackingOrderById(tOrderId)).called(1);
    });

    test('should return null when firebase service returns null', () async {
      // Arrange
      when(mockFirebaseService.getTrackingOrderById(any))
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase.call(tOrderId);

      // Assert
      expect(result, isNull);
      verify(mockFirebaseService.getTrackingOrderById(tOrderId)).called(1);
    });

    test('should throw an exception when firebase service throws', () async {
      // Arrange
      when(mockFirebaseService.getTrackingOrderById(any))
          .thenThrow(Exception('Firebase Error'));

      // Act & Assert
      expect(() => useCase.call(tOrderId), throwsException);
    });
  });
}