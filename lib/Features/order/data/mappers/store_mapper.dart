 import 'package:tracking_app/Features/order/data/models/store_dto.dart';
 import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';

extension StoreMapper on Store {
  StoreEntity toEntity() {
    return StoreEntity(
    name: name,
      image: image,
      address: address,
      latLong: latLong,
      phoneNumber: phoneNumber
    );
  }
}
