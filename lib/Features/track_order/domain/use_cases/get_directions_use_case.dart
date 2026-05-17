import 'package:injectable/injectable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tracking_app/Features/track_order/data/remote_data_source_contract/map_remote_data_source_contract.dart';

@injectable
class GetDirectionsUseCase {
  final MapRemoteDataSourceContract _repository;
  GetDirectionsUseCase(this._repository);

  Future<List<mapbox.Position>> call(
    mapbox.Position start,
    mapbox.Position end,
  ) {
    return _repository.getRoute(start, end);
  }
}
