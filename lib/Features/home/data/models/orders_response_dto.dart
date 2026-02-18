import 'package:json_annotation/json_annotation.dart';

part 'orders_response_dto.g.dart';

@JsonSerializable()
class OrdersResponseDto {
  final String? message;
  final MetadataDto? metadata;
  final List<OrderDto>? orders;

  OrdersResponseDto({this.message, this.metadata, this.orders});

  factory OrdersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseDtoFromJson(json);
}

@JsonSerializable()
class MetadataDto {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int? limit;

  MetadataDto({this.currentPage, this.totalPages, this.totalItems, this.limit});

  factory MetadataDto.fromJson(Map<String, dynamic> json) =>
      _$MetadataDtoFromJson(json);
}

@JsonSerializable()
class OrderDto {
  @JsonKey(name: '_id')
  final String? id;
  final UserDto? user;
  final List<OrderItemDto>? orderItems;
  final int? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? createdAt;
  final String? updatedAt;
  final String? orderNumber;
  final ShippingAddressDto? shippingAddress;
  final StoreDto? store;

  OrderDto({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.shippingAddress,
    this.store,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);
}

@JsonSerializable()
class UserDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;

  UserDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

@JsonSerializable()
class OrderItemDto {
  final ProductDto? product;
  final int? price;
  final int? quantity;
  @JsonKey(name: '_id')
  final String? id;

  OrderItemDto({this.product, this.price, this.quantity, this.id});

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);
}

@JsonSerializable()
class ProductDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  final String? slug;
  final String? description;
  final String? imgCover;
  final List<String>? images;
  final int? price;
  final int? priceAfterDiscount;
  final int? quantity;

  ProductDto({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.quantity,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}

@JsonSerializable()
class ShippingAddressDto {
  final String? street;
  final String? city;
  final String? phone;
  final String? lat;
  final String? long;

  ShippingAddressDto({this.street, this.city, this.phone, this.lat, this.long});

  factory ShippingAddressDto.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressDtoFromJson(json);
}

@JsonSerializable()
class StoreDto {
  final String? name;
  final String? image;
  final String? address;
  final String? phoneNumber;
  final String? latLong;

  StoreDto({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory StoreDto.fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);
}
