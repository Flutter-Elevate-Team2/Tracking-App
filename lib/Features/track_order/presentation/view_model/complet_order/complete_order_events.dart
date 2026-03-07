sealed class CompleteOrderEvents {}

class CompleteOrderEvent extends CompleteOrderEvents {
  final String orderId;
  CompleteOrderEvent({required this.orderId});
}