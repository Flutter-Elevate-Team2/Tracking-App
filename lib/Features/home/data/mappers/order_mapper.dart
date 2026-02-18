import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';

extension OrderResponseMapper on OrdersResponseDto {
  List<OrderEntity> toEntity() {
    return orders?.map((e) => e.toEntity()).toList() ?? [];
  }
}

extension OrderMapper on OrderDto {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id ?? "",
      user: user?.toEntity(),
      orderItems: orderItems?.map((e) => e.toEntity()).toList(),
      totalPrice: totalPrice,
      paymentType: paymentType,
      isPaid: isPaid,
      isDelivered: isDelivered,
      state: state,
      orderNumber: orderNumber,
      shippingAddress: shippingAddress?.toEntity(),
      store: store?.toEntity(),
    );
  }
}

extension UserMapper on UserDto {
  OrderUserEntity toEntity() {
    return OrderUserEntity(
      id: id ?? "",
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      email: email ?? "",
      phone: phone ?? "",
      photo: photo ?? "",
    );
  }
}

extension OrderItemMapper on OrderItemDto {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id ?? "",
      product: product?.toEntity(),
      price: price,
      quantity: quantity,
    );
  }
}

extension ProductMapper on ProductDto {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id ?? "",
      title: title ?? "",
      imgCover: imgCover ?? "",
      price: price,
    );
  }
}

extension ShippingAddressMapper on ShippingAddressDto {
  ShippingAddressEntity toEntity() {
    return ShippingAddressEntity(
      street: street,
      city: city,
      phone: phone,
      lat: lat,
      long: long,
    );
  }
}

extension StoreMapper on StoreDto {
  StoreEntity toEntity() {
    return StoreEntity(
      name: name,
      image: image,
      address: address,
      phoneNumber: phoneNumber,
      latLong: latLong,
    );
  }
}
