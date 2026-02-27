import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/store_dto.dart';

part 'driver_orders_dto.g.dart';


@JsonSerializable()
class DriverOrders {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "driver")
  final String? driver;
  @JsonKey(name: "order")
  final Order? order;
  @JsonKey(name: "__v")
  final int? V;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @JsonKey(name: "store")
  final Store? store;

  DriverOrders ({
    this.id,
    this.driver,
    this.order,
    this.V,
    this.createdAt,
    this.updatedAt,
    this.store,
  });

  factory DriverOrders.fromJson(Map<String, dynamic> json) {
    return _$DriverOrdersFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DriverOrdersToJson(this);
  }
}
