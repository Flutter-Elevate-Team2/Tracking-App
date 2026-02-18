import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/use_cases/start_order_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/location_service.dart';

@injectable
class AcceptOrderUseCase {
  final StartOrderUseCase _startOrderUseCase;
  final FirebaseOrderService _firebaseService;
  final SessionController _sessionController;
  final LocationService _locationService;
  final SharedPreferences _prefs;

  AcceptOrderUseCase(
    this._startOrderUseCase,
    this._firebaseService,
    this._sessionController,
    this._locationService,
    this._prefs,
  );

  Future<BaseResponse<OrderEntity>> call(OrderEntity order) async {
    // 1. Get user data from firebase (userid, device token)
    final userDataFirestore = await _firebaseService.getUserDataByOrderId(
      order.id,
    );

    // 2. Start order API
    final response = await _startOrderUseCase(order.id);

    if (response is SuccessResponse<OrderEntity>) {
      // 3. Upload tracking object to firebase
      final driver = _sessionController.user;
      final position = await _locationService.getCurrentLocation();

      final trackingModel = OrderTrackingFirebaseModel(
        userData: {
          'userId': userDataFirestore?['userId'] ?? order.user?.id,
          'deviceToken': userDataFirestore?['deviceToken'],
          'userName': order.user?.fullName,
          'userPhone': order.user?.phone,
        },
        orderData: {
          'orderId': order.id,
          'orderNumber': order.orderNumber,
          'totalPrice': order.totalPrice,
          'paymentType': order.paymentType,
          'shippingAddress': {
            'street': order.shippingAddress?.street,
            'city': order.shippingAddress?.city,
            'lat': order.shippingAddress?.lat,
            'long': order.shippingAddress?.long,
          },
        },
        driverData: {
          'driverId': driver?.id,
          'driverName': driver != null
              ? "${driver.firstName} ${driver.lastName}"
              : null,
          'driverPhone': driver?.phone,
          'vehicleNumber': driver?.vehicleNumber,
        },
        trackingLocation: {
          'lat': position?.latitude,
          'long': position?.longitude,
        },
        status: 'inProgress',
        updatedAt: DateTime.now(),
      );

      await _firebaseService.uploadTrackingOrder(
        order.id,
        trackingModel.toJson(),
      );

      // 4. Store order id to shared preferences
      await _prefs.setString(ApiConstants.currentOrderIdKey, order.id);
    }

    return response;
  }
}
