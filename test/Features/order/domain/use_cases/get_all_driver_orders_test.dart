import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';
import 'package:tracking_app/Features/order/domain/repo/order_repo_contract.dart';
import 'package:tracking_app/Features/order/domain/use_cases/get_all_driver_orders.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'get_all_driver_orders_test.mocks.dart';

@GenerateMocks([OrderRepoContract])
void main() {
  late GetAllDriverOrdersUseCase useCase;
  late MockOrderRepoContract mockRepo;

  setUp(() {
    mockRepo = MockOrderRepoContract();
    useCase = GetAllDriverOrdersUseCase(mockRepo);

    provideDummy<BaseResponse<DriverOrdersResponseEntity>>(
      SuccessResponse(data: DriverOrdersResponseEntity(orders: [])),
    );
  });

  group('GetAllDriverOrdersUseCase Unit Tests', () {

    test('Should return SuccessResponse<MyOrdersState> with correct mapped counts', () async {
      // Arrange
      final tOrders = [
        DriverOrdersEntity(order: OrderEntity(state: "completed")),
        DriverOrdersEntity(order: OrderEntity(state: "completed")),
        DriverOrdersEntity(order: OrderEntity(state: "canceled")),
        DriverOrdersEntity(order: OrderEntity(state: "pending")),
      ];
      final tResponseEntity = DriverOrdersResponseEntity(orders: tOrders);

      when(mockRepo.getAllDriverOrders())
          .thenAnswer((_) async => SuccessResponse(data: tResponseEntity));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<SuccessResponse<MyOrdersState>>());
      final successData = (result as SuccessResponse<MyOrdersState>).data;

      expect(successData.allOrders.length, 4);
      expect(successData.completedOrdersCount, 2);
      expect(successData.canceledOrdersCount, 1);

      verify(mockRepo.getAllDriverOrders()).called(1);
    });

    test('Should handle null orders list gracefully and return empty state', () async {
      // Arrange
      final tResponseEntity = DriverOrdersResponseEntity(orders: null);

      when(mockRepo.getAllDriverOrders())
          .thenAnswer((_) async => SuccessResponse(data: tResponseEntity));

      // Act
      final result = await useCase();

      // Assert
      final data = (result as SuccessResponse<MyOrdersState>).data;
      expect(data.allOrders, isEmpty);
      expect(data.completedOrdersCount, 0);
      expect(data.canceledOrdersCount, 0);
    });

    test('Should handle corrupted data (null nested objects) without crashing', () async {
      // Arrange
      final tCorruptedOrders = [
        DriverOrdersEntity(order: null),
      ];
      final tResponseEntity = DriverOrdersResponseEntity(orders: tCorruptedOrders);

      when(mockRepo.getAllDriverOrders())
          .thenAnswer((_) async => SuccessResponse(data: tResponseEntity));

      // Act
      final result = await useCase();

      // Assert
      final data = (result as SuccessResponse<MyOrdersState>).data;
      expect(data.completedOrdersCount, 0);
      expect(data.canceledOrdersCount, 0);
    });

    test('Should return ErrorResponse with the same message when Repository fails', () async {
      // Arrange
      const tErrorMessage = "Network Connection Failed";
      when(mockRepo.getAllDriverOrders())
          .thenAnswer((_) async => ErrorResponse(errorMessage: tErrorMessage));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<ErrorResponse<MyOrdersState>>());
      expect((result as ErrorResponse).errorMessage, tErrorMessage);
      verify(mockRepo.getAllDriverOrders()).called(1);
    });

    test('Should return "Unknown error" when response is neither Success nor Error', () async {
      // Arrange
      when(mockRepo.getAllDriverOrders()).thenAnswer((_) async => ErrorResponse(errorMessage: "Unknown error"));

      // Act
      final result = await useCase();

      // Assert
      expect((result as ErrorResponse).errorMessage, "Unknown error");
    });
  });
}

