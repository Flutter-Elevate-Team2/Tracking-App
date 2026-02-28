import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';


class DriverOrdersEntity extends Equatable{
  final String? id;
   final String? driver;
   final OrderEntity? order;
   final int? V;
   final String? createdAt;
   final String? updatedAt;
   final StoreEntity? store;

  const DriverOrdersEntity ({
    this.id,
    this.driver,
    this.order,
    this.V,
    this.createdAt,
    this.updatedAt,
    this.store,
  });
  @override
  List<Object?> get props => [id, store ,V,createdAt ,updatedAt ,order ,driver];

}
