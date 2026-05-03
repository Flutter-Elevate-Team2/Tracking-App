import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';

class UpdateOrderResponseEntity extends Equatable {
  final String? message;
  final OrderEntity? order;

  const UpdateOrderResponseEntity ({
    this.message,
    this.order,
  });


  @override
  List<Object?> get props => [message, order];

}

