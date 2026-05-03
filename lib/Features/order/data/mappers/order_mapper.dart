
import 'package:tracking_app/Features/order/data/mappers/order_item_mapper.dart';
import 'package:tracking_app/Features/order/data/mappers/user_mapper.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';

extension OrderMapper on Order{
  OrderEntity toEntity() {
    return OrderEntity(
      user: user?.toEntity(),
      orderItems: orderItems?.map((e) => e.toEntity()).toList(),
      totalPrice: totalPrice,
      paymentType: paymentType,
      isPaid: isPaid,
      isDelivered: isDelivered,
      state: state,
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      orderNumber: orderNumber,
    );
  }
}
