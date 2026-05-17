
import 'package:tracking_app/Features/order/data/mappers/order_mapper.dart';
import 'package:tracking_app/Features/order/data/mappers/store_mapper.dart';
import 'package:tracking_app/Features/order/data/models/driver_orders_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';

extension DriverOrdersMapper on DriverOrders{
  DriverOrdersEntity toEntity() {
    return DriverOrdersEntity(
      id: id,
      driver: driver,
      order: order?.toEntity(),
      V: V,
      store: store?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
