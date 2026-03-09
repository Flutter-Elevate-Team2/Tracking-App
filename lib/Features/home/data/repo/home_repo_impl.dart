import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/home/data/data_sources/home_data_source_contract.dart';
import 'package:tracking_app/Features/home/data/mappers/order_mapper.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';

@Injectable(as: HomeRepoContract)
class HomeRepoImpl with ApiExecutionMixin implements HomeRepoContract {
  final HomeDataSourceContract _dataSource;

  HomeRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<HomeOrdersEntity>> getPendingOrders({
    required int currentPage,
    required bool isRefresh,
  }) async {
    // Step 1: Determine the target page
    int targetPage;

    if (isRefresh || currentPage <= 1) {
      // Initial load or refresh: fetch page 1 to discover totalPages
      final metaResult = await execute(
        action: () => _dataSource.getPendingOrders(1),
        mapper: (response) => response.toHomeOrdersEntity(),
      );

      if (metaResult is ErrorResponse<HomeOrdersEntity>) {
        return metaResult;
      }

      final metaData = (metaResult as SuccessResponse<HomeOrdersEntity>).data;
      final totalPages = metaData.totalPages;

      if (totalPages <= 1) {
        // Only 1 page exists — sort and return it directly
        final sortedOrders = List<OrderEntity>.from(metaData.orders)
          ..sort(
            (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
              a.createdAt ?? DateTime(0),
            ),
          );
        return SuccessResponse(
          data: HomeOrdersEntity(
            orders: sortedOrders,
            totalPages: totalPages,
            currentPage: 1,
          ),
        );
      }

      // More than 1 page: fetch the LAST page (newest orders)
      targetPage = totalPages;
    } else {
      // Pagination: fetch the previous page
      targetPage = currentPage - 1;
      if (targetPage < 1) {
        return const SuccessResponse(
          data: HomeOrdersEntity(orders: [], totalPages: 1, currentPage: 0),
        );
      }
    }

    // Step 2: Fetch the target page
    final result = await execute(
      action: () => _dataSource.getPendingOrders(targetPage),
      mapper: (response) => response.toHomeOrdersEntity(),
    );

    if (result is SuccessResponse<HomeOrdersEntity>) {
      // Step 3: Sort by createdAt descending
      final sortedOrders = List<OrderEntity>.from(result.data.orders)
        ..sort(
          (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
            a.createdAt ?? DateTime(0),
          ),
        );

      return SuccessResponse(
        data: HomeOrdersEntity(
          orders: sortedOrders,
          totalPages: result.data.totalPages,
          currentPage: targetPage,
        ),
      );
    }

    return result;
  }

  @override
  Future<BaseResponse<OrderEntity>> startOrder(String id) async {
    return await execute(
      action: () => _dataSource.startOrder(id),
      mapper: (response) => response.orders!.toEntity(),
    );
  }
}
