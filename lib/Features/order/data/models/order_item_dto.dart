import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/Features/order/data/models/product_dto.dart';

part 'order_item_dto.g.dart';


@JsonSerializable()
class OrderItems {
  @JsonKey(name: "product")
  final Product? product;
  @JsonKey(name: "price")
  final int? price;
  @JsonKey(name: "quantity")
  final int? quantity;
  @JsonKey(name: "_id")
  final String? id;

  OrderItems ({
    this.product,
    this.price,
    this.quantity,
    this.id,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return _$OrderItemsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OrderItemsToJson(this);
  }
}
