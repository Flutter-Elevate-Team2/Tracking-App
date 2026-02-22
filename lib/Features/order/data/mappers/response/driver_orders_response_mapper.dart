
import 'package:tracking_app/Features/order/data/mappers/driver_orders_mapper.dart';
import 'package:tracking_app/Features/order/data/mappers/metadata_mapper.dart';
import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';

extension DriverOrdersResponsMapper on DriverOrdersResponse {
  DriverOrdersResponseEntity toEntity() {
    return DriverOrdersResponseEntity(
      message: message,
      metadata: metadata!.toEntity(),
      orders: orders?.map((e) => e.toEntity()).toList(),
    );
  }
}
