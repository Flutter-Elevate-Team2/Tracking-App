import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/data/data_sources/home_data_source_contract.dart';
import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';
import 'package:tracking_app/Features/home/data/models/start_order_response_dto.dart';
import 'package:tracking_app/Features/home/data/repo/home_repo_impl.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'home_repo_test.mocks.dart';

@GenerateMocks([HomeDataSourceContract])
void main() {
  late MockHomeDataSourceContract mockDataSource;
  late HomeRepoImpl repo;

  setUp(() {
    mockDataSource = MockHomeDataSourceContract();
    repo = HomeRepoImpl(mockDataSource);
  });

  group('HomeRepoImpl Tests', () {
    test('getPendingOrders returns SuccessResponse on success', () async {
      final mockDto = OrdersResponseDto(
        message: 'success',
        orders: [OrderDto(id: '1', orderNumber: '#123')],
        metadata: MetadataDto(totalPages: 1),
      );
      when(mockDataSource.getPendingOrders(1)).thenAnswer((_) async => mockDto);

      final result = await repo.getPendingOrders(1);

      expect(result, isA<SuccessResponse<HomeOrdersEntity>>());
      final data = (result as SuccessResponse<HomeOrdersEntity>).data;
      expect(data.orders.length, 1);
      expect(data.orders[0].id, '1');
      expect(data.totalPages, 1);
    });

    test('startOrder returns SuccessResponse on success', () async {
      final mockDto = StartOrderResponseDto(
        message: 'success',
        orders: OrderDto(id: '1', orderNumber: '#123'),
      );
      when(mockDataSource.startOrder(any)).thenAnswer((_) async => mockDto);

      final result = await repo.startOrder('1');

      expect(result, isA<SuccessResponse<OrderEntity>>());
      final data = (result as SuccessResponse<OrderEntity>).data;
      expect(data.id, '1');
    });

    test('getPendingOrders returns ErrorResponse on failure', () async {
      when(mockDataSource.getPendingOrders(1)).thenThrow(Exception('error'));

      final result = await repo.getPendingOrders(1);

      expect(result, isA<ErrorResponse<HomeOrdersEntity>>());
    });
  });
}
