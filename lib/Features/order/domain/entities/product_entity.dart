import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;

  final String? title;
  final String? slug;
  final String? description;
  final String? imgCover;
  final List<String>? images;
  final int? price;
  final int? priceAfterDiscount;
  final int? quantity;
  final String? category;
  final String? occasion;
  final String? createdAt;
  final String? updatedAt;
  final int? V;
  final int? sold;
  final bool? isSuperAdmin;
  final int? rateAvg;
  final int? rateCount;

  const ProductEntity({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.quantity,
    this.category,
    this.occasion,
    this.createdAt,
    this.updatedAt,
    this.V,
    this.sold,
    this.isSuperAdmin,
    this.rateAvg,
    this.rateCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    description,
    imgCover,
    images,
    price,
    priceAfterDiscount,
    quantity,
    category,
    occasion,
    createdAt,
    updatedAt,
    V,
    sold,
    isSuperAdmin,
    rateAvg,
    rateCount,
  ];
}
