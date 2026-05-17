import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';
import 'package:tracking_app/Features/home/data/repo/home_repo_impl.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'home_repo_test.mocks.dart';

void main() {
  late MockHomeDataSourceContract mockDataSource;
  late HomeRepoImpl repo;

  setUp(() {
    mockDataSource = MockHomeDataSourceContract();
    repo = HomeRepoImpl(mockDataSource);
  });

  group('HomeRepoImpl Pagination Tests', () {
    test('getPendingOrders with totalPages > 1 fetches last page', () async {
      // First call (page 1) reveals totalPages = 3
      final metaDto = OrdersResponseDto(
        metadata: MetadataDto(totalPages: 3),
        orders: [OrderDto(id: 'o1', createdAt: '2024-01-01T00:00:00Z')],
      );
      // Second call fetches last page (page 3)
      final lastPageDto = OrdersResponseDto(
        metadata: MetadataDto(totalPages: 3),
        orders: [
          OrderDto(id: 'o3', createdAt: '2024-01-03T00:00:00Z'),
          OrderDto(id: 'o2', createdAt: '2024-01-02T00:00:00Z'),
        ],
      );
      when(mockDataSource.getPendingOrders(1)).thenAnswer((_) async => metaDto);
      when(
        mockDataSource.getPendingOrders(3),
      ).thenAnswer((_) async => lastPageDto);

      final result = await repo.getPendingOrders(
        currentPage: 1,
        isRefresh: false,
      );

      expect(result, isA<SuccessResponse<HomeOrdersEntity>>());
      final data = (result as SuccessResponse<HomeOrdersEntity>).data;
      // Should have results sorted by date desc (newest first)
      expect(data.orders.length, 2);
      expect(data.orders.first.id, 'o3');
      expect(data.totalPages, 3);
    });

    test(
      'getPendingOrders pagination: currentPage > 1 fetches previous page',
      () async {
        // currentPage=3, targetPage = 3-1 = 2
        final prevPageDto = OrdersResponseDto(
          metadata: MetadataDto(totalPages: 5),
          orders: [OrderDto(id: 'o2', createdAt: '2024-01-02T00:00:00Z')],
        );
        when(
          mockDataSource.getPendingOrders(2),
        ).thenAnswer((_) async => prevPageDto);

        final result = await repo.getPendingOrders(
          currentPage: 3,
          isRefresh: false,
        );

        expect(result, isA<SuccessResponse<HomeOrdersEntity>>());
        final data = (result as SuccessResponse<HomeOrdersEntity>).data;
        expect(data.orders.first.id, 'o2');
        expect(data.currentPage, 2);
      },
    );

    test(
      'getPendingOrders isRefresh=true: meta fails returns ErrorResponse',
      () async {
        when(
          mockDataSource.getPendingOrders(1),
        ).thenThrow(Exception('network failed'));

        final result = await repo.getPendingOrders(
          currentPage: 1,
          isRefresh: true,
        );

        expect(result, isA<ErrorResponse<HomeOrdersEntity>>());
      },
    );

    test(
      'getPendingOrders pagination: second page fetch fails returns ErrorResponse',
      () async {
        // Page 1 succeeds with totalPages > 1 but page 3 fails
        final metaDto = OrdersResponseDto(
          metadata: MetadataDto(totalPages: 3),
          orders: [OrderDto(id: 'o1')],
        );
        when(
          mockDataSource.getPendingOrders(1),
        ).thenAnswer((_) async => metaDto);
        when(
          mockDataSource.getPendingOrders(3),
        ).thenThrow(Exception('page 3 failed'));

        final result = await repo.getPendingOrders(
          currentPage: 1,
          isRefresh: false,
        );

        expect(result, isA<ErrorResponse<HomeOrdersEntity>>());
      },
    );

    test(
      'getPendingOrders sorts orders by createdAt descending (oldest→newest reversed)',
      () async {
        final dto = OrdersResponseDto(
          metadata: MetadataDto(totalPages: 1),
          orders: [
            OrderDto(id: 'old', createdAt: '2024-01-01T00:00:00Z'),
            OrderDto(id: 'new', createdAt: '2024-01-05T00:00:00Z'),
            OrderDto(id: 'mid', createdAt: '2024-01-03T00:00:00Z'),
          ],
        );
        when(mockDataSource.getPendingOrders(1)).thenAnswer((_) async => dto);

        final result = await repo.getPendingOrders(
          currentPage: 1,
          isRefresh: true,
        );

        final data = (result as SuccessResponse<HomeOrdersEntity>).data;
        expect(data.orders[0].id, 'new');
        expect(data.orders[1].id, 'mid');
        expect(data.orders[2].id, 'old');
      },
    );

    test('getPendingOrders pagination: sorted result', () async {
      // currentPage=4, targetPage = 3
      final pageDto = OrdersResponseDto(
        metadata: MetadataDto(totalPages: 5),
        orders: [
          OrderDto(id: 'b', createdAt: '2024-01-02T00:00:00Z'),
          OrderDto(id: 'a', createdAt: '2024-01-05T00:00:00Z'),
        ],
      );
      when(mockDataSource.getPendingOrders(3)).thenAnswer((_) async => pageDto);

      final result = await repo.getPendingOrders(
        currentPage: 4,
        isRefresh: false,
      );

      expect(result, isA<SuccessResponse<HomeOrdersEntity>>());
      final data = (result as SuccessResponse<HomeOrdersEntity>).data;
      expect(data.orders.first.id, 'a'); // newest first
    });

    test('startOrder returns ErrorResponse when data source throws', () async {
      when(mockDataSource.startOrder(any)).thenThrow(Exception('error'));

      final result = await repo.startOrder('1');

      expect(result, isA<ErrorResponse<OrderEntity>>());
    });
  });
}
