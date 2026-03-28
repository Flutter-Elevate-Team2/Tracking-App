import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/order/data/data_source/order_remote_data_source/order_remote_data_source_contract.dart';
import 'package:tracking_app/Features/order/data/models/driver_orders_dto.dart';
import 'package:tracking_app/Features/order/data/models/metadata_dto.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';
import 'package:tracking_app/Features/order/data/repo/order_repo_imple.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/response/update_order_response_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'order_repo_imple_test.mocks.dart';

@GenerateMocks([OrderRemoteDataSourceContract])
void main() {
  late MockOrderRemoteDataSourceContract mockDataSource;
  late OrderRepoImple repo;

  setUp(() {
    mockDataSource = MockOrderRemoteDataSourceContract();
    repo = OrderRepoImple(mockDataSource);
  });

  group('OrderRepoImple Tests', () {
    test('getAllDriverOrders returns SuccessResponse on success', () async {
      final mockDto = DriverOrdersResponse(
        message: 'success',
        orders: [DriverOrders()],
        metadata: Metadata(),
      );

      when(mockDataSource.getAllDriverOrders())
          .thenAnswer((_) async => mockDto);

      final result = await repo.getAllDriverOrders();

      expect(result, isA<SuccessResponse<DriverOrdersResponseEntity>>());

      final data =
          (result as SuccessResponse<DriverOrdersResponseEntity>).data;

      expect(data.orders!.length , 1);
      expect(data.message, 'success');
    });

    test('getAllDriverOrders returns ErrorResponse on failure', () async {
      when(mockDataSource.getAllDriverOrders())
          .thenThrow(Exception('error'));

      final result = await repo.getAllDriverOrders();

      expect(result, isA<ErrorResponse>());
    });
  });
  group('updateOrderState Tests', () {
    test('updateOrderState returns SuccessResponse on success', () async {
      // Mock DTO / Response من الـ data source
      final mockDto = UpdateOrderResponse(
        message: 'success',
        orders: Order(),
      );

      // لما الـ repo يستدعي dataSource
      when(mockDataSource.updateOrderState("1", "completed"))
          .thenAnswer((_) async => mockDto);

      final result = await repo.updateOrderState("1", "completed");

      expect(result, isA<SuccessResponse<UpdateOrderResponseEntity>>());

      final data = (result as SuccessResponse<UpdateOrderResponseEntity>).data;

      expect(data.message, 'success');
      expect(data.order, isNotNull);
    });

    test('updateOrderState returns ErrorResponse on failure', () async {
      when(mockDataSource.updateOrderState("1", "completed"))
          .thenThrow(Exception('API error'));

      final result = await repo.updateOrderState("1", "completed");

      expect(result, isA<ErrorResponse>());
    });
  });
}