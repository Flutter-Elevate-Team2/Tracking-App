

import 'package:tracking_app/Features/order/data/mappers/product_mapper.dart';
import 'package:tracking_app/Features/order/data/models/order_item_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/orders_item_entity.dart';

extension OrderItemMapper on OrderItems{
  OrdersItemEntity toEntity(){
    return OrdersItemEntity(
        id:id,
        product:product?.toEntity() ,
        price:price ,
        quantity: quantity);
  }
}