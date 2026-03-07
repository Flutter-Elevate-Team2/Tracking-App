import 'package:json_annotation/json_annotation.dart';

import 'orders.order_response.dart';

part 'complete.order_response.g.dart';

@JsonSerializable()
class CompleteOrderResponse {
  String? message;
  Orders? orders;

  CompleteOrderResponse({this.message, this.orders});

  factory CompleteOrderResponse.fromJson(Map<String, dynamic> json) {
    return _$CompleteOrderResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CompleteOrderResponseToJson(this);
}
