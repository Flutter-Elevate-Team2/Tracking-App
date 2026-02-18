import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/home/api/home_api_client/home_api_client.dart';
import 'package:tracking_app/Features/home/data/data_sources/home_data_source_contract.dart';
import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';
import 'package:tracking_app/Features/home/data/models/start_order_response_dto.dart';

@Injectable(as: HomeDataSourceContract)
class HomeDataSourceImpl implements HomeDataSourceContract {
  final HomeApiClient _apiClient;

  HomeDataSourceImpl(this._apiClient);

  @override
  Future<OrdersResponseDto> getPendingOrders() async {
    return await _apiClient.getPendingOrders();
  }

  @override
  Future<StartOrderResponseDto> startOrder(String id) async {
    return await _apiClient.startOrder(id);
  }
}
