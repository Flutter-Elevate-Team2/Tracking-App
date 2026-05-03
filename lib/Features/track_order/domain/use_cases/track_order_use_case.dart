import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/push_notification_service.dart';

@injectable
class UpdateOrderStatusUseCase {
  final FirebaseOrderService _firebaseService;

  UpdateOrderStatusUseCase(this._firebaseService);

  Future<void> call({
    required String orderId,
    required OrderStatus status,
    required String userToken,
    required String title,
    required String body,
  }) async {
    // 1. Update Firebase Database
    await _firebaseService.uploadTrackingOrder(orderId, {
      "status": status.firebaseValue,
      "updatedAt": DateTime.now(),
    });

    // 2. Send Notification if token exists
    if (userToken.isNotEmpty) {
      await PushNotificationService.sendNotification(
        token: userToken,
        title: title,
        body: body,
        data: {
          "orderId": orderId,
          "status": status.firebaseValue,
        },
      );
    }
  }
}
