import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/metadata_entity.dart';


class DriverOrdersResponseEntity extends Equatable {
  final String? message;
   final MetadataEntity? metadata;
  final List<DriverOrdersEntity>? orders;

 const DriverOrdersResponseEntity ({
    this.message,
    this.metadata,
    this.orders,
  });

  @override
  List<Object?> get props => [message, metadata, orders];


}



