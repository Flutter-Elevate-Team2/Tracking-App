import 'package:tracking_app/Features/order/data/mappers/order_mapper.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';
import 'package:tracking_app/Features/order/domain/entities/response/update_order_response_entity.dart';

extension UpdateOrderStateMapper on UpdateOrderResponse {
  UpdateOrderResponseEntity toEntity() {
    return UpdateOrderResponseEntity(
      message: message,
      order: orders?.toEntity(),
    );
  }
}
