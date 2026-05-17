import 'package:json_annotation/json_annotation.dart';

import 'orders_response_dto.dart';

part 'start_order_response_dto.g.dart';

@JsonSerializable()
class StartOrderResponseDto {
  final String? message;
  final OrderDto? orders;

  StartOrderResponseDto({this.message, this.orders});

  factory StartOrderResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StartOrderResponseDtoFromJson(json);
}
