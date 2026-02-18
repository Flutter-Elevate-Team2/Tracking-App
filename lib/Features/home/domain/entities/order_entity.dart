import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final OrderUserEntity? user;
  final List<OrderItemEntity>? orderItems;
  final int? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? orderNumber;
  final ShippingAddressEntity? shippingAddress;
  final StoreEntity? store;

  const OrderEntity({
    required this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.orderNumber,
    this.shippingAddress,
    this.store,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    orderItems,
    totalPrice,
    paymentType,
    isPaid,
    isDelivered,
    state,
    orderNumber,
    shippingAddress,
    store,
  ];
}

class OrderUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String photo;

  const OrderUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.photo,
  });

  String get fullName => "$firstName $lastName";

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone, photo];
}

class OrderItemEntity extends Equatable {
  final ProductEntity? product;
  final int? price;
  final int? quantity;
  final String id;

  const OrderItemEntity({
    this.product,
    this.price,
    this.quantity,
    required this.id,
  });

  @override
  List<Object?> get props => [product, price, quantity, id];
}

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String imgCover;
  final int? price;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.imgCover,
    this.price,
  });

  @override
  List<Object?> get props => [id, title, imgCover, price];
}

class ShippingAddressEntity extends Equatable {
  final String? street;
  final String? city;
  final String? phone;
  final String? lat;
  final String? long;

  const ShippingAddressEntity({
    this.street,
    this.city,
    this.phone,
    this.lat,
    this.long,
  });

  @override
  List<Object?> get props => [street, city, phone, lat, long];
}

class StoreEntity extends Equatable {
  final String? name;
  final String? image;
  final String? address;
  final String? phoneNumber;
  final String? latLong;

  const StoreEntity({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  @override
  List<Object?> get props => [name, image, address, phoneNumber, latLong];
}
