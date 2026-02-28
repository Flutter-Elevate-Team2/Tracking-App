import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/Features/order/data/models/driver_orders_dto.dart';
import 'package:tracking_app/Features/order/data/models/metadata_dto.dart';

part 'driver_orders_response.g.dart';

@JsonSerializable()
class DriverOrdersResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "metadata")
  final Metadata? metadata;
  @JsonKey(name: "orders")
  final List<DriverOrders>? orders;

  DriverOrdersResponse ({
    this.message,
    this.metadata,
    this.orders,
  });

  factory DriverOrdersResponse.fromJson(Map<String, dynamic> json) {
    return _$DriverOrdersResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DriverOrdersResponseToJson(this);
  }
}



