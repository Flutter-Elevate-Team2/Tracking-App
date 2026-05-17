import 'package:json_annotation/json_annotation.dart';

import 'order_item.dart';
import 'shipping_address.dart';

part 'orders.g.dart';

@JsonSerializable(explicitToJson: true)
class Orders {
  ShippingAddress? shippingAddress;
  @JsonKey(name: '_id')
  String? id;
  String? user;
  List<OrderItem>? orderItems;
  num? totalPrice;
  String? paymentType;
  bool? isPaid;
  DateTime? paidAt;
  bool? isDelivered;
  String? state;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderNumber;
  @JsonKey(name: '__v')
  num? v;

  Orders({
    this.shippingAddress,
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.paidAt,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return _$OrdersFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OrdersToJson(this);
}
