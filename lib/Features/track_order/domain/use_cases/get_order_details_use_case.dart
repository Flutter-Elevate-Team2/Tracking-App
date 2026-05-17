import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/track_order/data/mapper/order_tracking_mapper.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';

@injectable
class GetOrderDetailsUseCase {
  final FirebaseOrderService _firebaseService;

  GetOrderDetailsUseCase(this._firebaseService);

  Future<OrderTrackingEntity?> call(String orderId) async {
    final firebaseModel = await _firebaseService.getTrackingOrderById(orderId);
    return firebaseModel?.toEntity();
  }
}
