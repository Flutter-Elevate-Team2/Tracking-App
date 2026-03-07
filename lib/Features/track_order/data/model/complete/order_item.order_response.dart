import 'package:json_annotation/json_annotation.dart';

part 'order_item.order_response.g.dart';

@JsonSerializable()
class OrderItem {
  String? product;
  num? price;
  num? quantity;
  @JsonKey(name: '_id')
  String? id;

  OrderItem({this.product, this.price, this.quantity, this.id});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return _$OrderItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
