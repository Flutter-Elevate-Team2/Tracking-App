import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/order/domain/entities/product_entity.dart';

class OrdersItemEntity extends Equatable {
  final ProductEntity? product;

  final int? price;

  final int? quantity;
  final String? id;

  const OrdersItemEntity({this.product, this.price, this.quantity, this.id});
  OrdersItemEntity copyWith(
      ProductEntity? product,
      int price,
      int quantity,
      String id,
      ) {
    return OrdersItemEntity(
      id: id,
      quantity: quantity,
      price: price,
      product: product,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [product, price, quantity, id];
}