import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tracking_app/Features/order/api/api_client/order_api.dart';
import 'package:tracking_app/Features/order/api/data_source_imple/remot_data_source_imple/order_remote_data_source_imple.dart';
import 'package:tracking_app/Features/order/data/models/metadata_dto.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';

@GenerateMocks([OrderApi])
import 'order_remote_data_source_imple_test.mocks.dart';

void main() {
  late OrderRemoteDataSourceImple dataSource;
  late MockOrderApi mockOrderApi;

  setUp(() {
    mockOrderApi = MockOrderApi();
    dataSource = OrderRemoteDataSourceImple(mockOrderApi);
  });

  group('OrderRemoteDataSourceImple Tests', () {
    test('getAllDriverOrders returns DriverOrdersResponse on success', () async {
      final mockResponse = DriverOrdersResponse(
        message: 'success',
        orders: [],
        metadata: Metadata(),
      );

      when(mockOrderApi.getAllDriverOrders())
          .thenAnswer((_) async => mockResponse);

      final result = await dataSource.getAllDriverOrders();

      expect(result, mockResponse);
      verify(mockOrderApi.getAllDriverOrders()).called(1);
    });
    test('getAllDriverOrders throws exception on failure', () async {
      when(mockOrderApi.getAllDriverOrders()).thenThrow(Exception('API error'));

      expect(
            () async => await dataSource.getAllDriverOrders(),
        throwsA(isA<Exception>()),
      );
    });
    test('updateOrderState returns  success', () async {
      final mockResponse = UpdateOrderResponse(
        message: 'success',
        orders: Order(),
      );

      when(mockOrderApi.updateOrderState("1", "completed"))
          .thenAnswer((_) async => mockResponse);

      final result = await dataSource.updateOrderState("1", "completed");

      expect(result, mockResponse);
      verify(mockOrderApi.updateOrderState("1", "completed")).called(1);
    });
    test('updateOrderState throws exception on failure', () async {
      when(mockOrderApi.updateOrderState("1", "completed"))
          .thenThrow(Exception('API error'));

      expect(
            () async => await dataSource.updateOrderState("1", "completed"),
        throwsA(isA<Exception>()),
      );
    });
  });
}