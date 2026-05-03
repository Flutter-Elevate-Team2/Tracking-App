import 'package:equatable/equatable.dart';

class MetadataEntity extends Equatable {
  final int? currentPage;
  final int? totalPages;
  final int? limit;
  final int? totalItems;

  const MetadataEntity({
    this.currentPage,
    this.totalPages,
    this.limit,
    this.totalItems,
  });

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    limit,
    totalItems,
  ];
}
