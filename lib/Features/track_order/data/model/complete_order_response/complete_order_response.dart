import 'package:json_annotation/json_annotation.dart';

import 'orders.dart';

part 'complete_order_response.g.dart';

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
