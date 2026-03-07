import 'package:equatable/equatable.dart';
class CompleteOrderEntity extends Equatable {
  final String message;
  final String orderId;
  final String orderNumber;
  final String state;
  final num totalPrice;
  final String paymentType;

  const CompleteOrderEntity({
    required this.message,
    required this.orderId,
    required this.orderNumber,
    required this.state,
    required this.totalPrice,
    required this.paymentType,
  });

  @override
  List<Object?> get props => [
        message,
        orderId,
        orderNumber,
        state,
        totalPrice,
        paymentType,
      ];
}