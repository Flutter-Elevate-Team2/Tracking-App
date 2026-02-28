import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/order/domain/entities/orders_item_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/user_entity.dart';

class OrderEntity extends Equatable{
  final String? id;
  final UserEntity? user;
  final List<OrdersItemEntity>? orderItems;
  final int? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? createdAt;
  final String? updatedAt;
  final String? orderNumber;

  const OrderEntity({
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
  });


  OrderEntity copyWith(
      UserEntity user,
      List<OrdersItemEntity> orderItems,
      int totalPrice,
      String paymentType,
      bool isPaid,
      bool isDelivered,
      String state,
      String id,
      String createdAt,
      String updatedAt,
      String orderNumber
      ){
    return OrderEntity(
      user: user,
      orderItems: orderItems,
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

  @override
  List<Object?> get props => [id,totalPrice,user,paymentType,isPaid,isDelivered,state,orderItems,createdAt,updatedAt,orderNumber];


}