import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/data/mapper/complet_order_mapper.dart';
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/complete_order_response.dart';
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/orders.dart';

void main() {
  group('CompleteOrderMapper Test', () {
    test(
      'toEntity should map CompleteOrderResponse to CompleteOrderEntity correctly',
      () {
        // Arrange
        final response = CompleteOrderResponse(
          message: 'Success',
          orders: Orders(
            id: '123',
            orderNumber: 'ORD-001',
            state: 'completed',
            totalPrice: 150.0,
            paymentType: 'card',
          ),
        );

        // Act
        final entity = response.toEntity();

        // Assert
        expect(entity.message, 'Success');
        expect(entity.orderId, '123');
        expect(entity.orderNumber, 'ORD-001');
        expect(entity.state, 'completed');
        expect(entity.totalPrice, 150.0);
        expect(entity.paymentType, 'card');
      },
    );

    test(
      'toEntity should use default values when CompleteOrderResponse is null',
      () {
        // Arrange
        const CompleteOrderResponse? response = null;

        // Act
        final entity = response.toEntity();

        // Assert
        expect(entity.message, 'تم إنهاء الطلب');
        expect(entity.orderId, '');
        expect(entity.orderNumber, '');
        expect(entity.state, '');
        expect(entity.totalPrice, 0);
        expect(entity.paymentType, 'cash');
      },
    );

    test(
      'toEntity should use default values when orders are null in CompleteOrderResponse',
      () {
        // Arrange
        final response = CompleteOrderResponse(
          message: 'Custom Message',
          orders: null,
        );

        // Act
        final entity = response.toEntity();

        // Assert
        expect(entity.message, 'Custom Message');
        expect(entity.orderId, '');
        expect(entity.orderNumber, '');
        expect(entity.state, '');
        expect(entity.totalPrice, 0);
        expect(entity.paymentType, 'cash');
      },
    );
  });
}
