
import 'package:tracking_app/Features/order/data/models/metadata_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/metadata_entity.dart';

extension MetadataMapper on Metadata {
  MetadataEntity toEntity() {
    return MetadataEntity(
      currentPage: currentPage,
      totalItems: totalItems,
      totalPages: totalPages,
      limit: limit,
    );
  }
}
