import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/api/data_source/home_data_source_impl.dart';
import 'package:tracking_app/Features/home/api/home_api_client/home_api_client.dart';
import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';
import 'package:tracking_app/Features/home/data/models/start_order_response_dto.dart';

import 'home_data_source_test.mocks.dart';

@GenerateMocks([HomeApiClient])
void main() {
  late MockHomeApiClient mockApiClient;
  late HomeDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockHomeApiClient();
    dataSource = HomeDataSourceImpl(mockApiClient);
  });

  group('HomeDataSourceImpl Tests', () {
    test('getPendingOrders returns OrdersResponseDto on success', () async {
      final mockResponse = OrdersResponseDto(message: 'success', orders: []);
      when(
        mockApiClient.getPendingOrders(),
      ).thenAnswer((_) async => mockResponse);

      final result = await dataSource.getPendingOrders();

      expect(result, mockResponse);
      verify(mockApiClient.getPendingOrders()).called(1);
    });

    test('startOrder returns StartOrderResponseDto on success', () async {
      final mockResponse = StartOrderResponseDto(message: 'success');
      when(mockApiClient.startOrder(any)).thenAnswer((_) async => mockResponse);

      final result = await dataSource.startOrder('123');

      expect(result, mockResponse);
      verify(mockApiClient.startOrder('123')).called(1);
    });
  });
}
