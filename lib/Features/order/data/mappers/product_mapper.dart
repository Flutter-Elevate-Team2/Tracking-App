import 'package:tracking_app/Features/order/data/models/product_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/product_entity.dart';

extension ProductMapper on Product {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      description: description,
      price: price,
      quantity: quantity,
      images: images,
      imgCover: imgCover,
      title: title,
      slug: slug,
      category: category,
      occasion: occasion,
      sold: sold,
      rateAvg: rateAvg,
      rateCount: rateCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      V: V,
      isSuperAdmin: isSuperAdmin,
      priceAfterDiscount: priceAfterDiscount,
    );
  }
}
