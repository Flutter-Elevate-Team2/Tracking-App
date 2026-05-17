import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/complete_order_response.dart';
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/orders.dart';

void main() {
  group('CompleteOrderResponse Model Test', () {
    test('fromJson should return a valid model', () {
      final json = {
        'message': 'Success',
        'orders': {
          '_id': '123',
          'orderNumber': 'ORD-1',
          'state': 'completed',
          'totalPrice': 100,
        },
      };

      final result = CompleteOrderResponse.fromJson(json);

      expect(result.message, 'Success');
      expect(result.orders?.id, '123');
      expect(result.orders?.orderNumber, 'ORD-1');
      expect(result.orders?.state, 'completed');
      expect(result.orders?.totalPrice, 100);
    });

    test('toJson should return a valid Map', () {
      final response = CompleteOrderResponse(
        message: 'Success',
        orders: Orders(id: '123', orderNumber: 'ORD-1'),
      );

      final result = response.toJson();

      expect(result['message'], 'Success');
      expect(result['orders']['_id'], '123');
      expect(result['orders']['orderNumber'], 'ORD-1');
    });
  });
}
