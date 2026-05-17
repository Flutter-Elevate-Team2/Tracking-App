import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/use_cases/start_order_use_case.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_driver_profile_use_case.dart';
import 'package:tracking_app/Features/vehicle/domain/use_cases/get_vehicle_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/location_service.dart';
import 'package:tracking_app/core/services/push_notification_service.dart';

import '../../../vehicle/domain/entities/vehicle_entity.dart';

@injectable
class AcceptOrderUseCase {
  final StartOrderUseCase _startOrderUseCase;
  final FirebaseOrderService _firebaseService;
  final SessionController _sessionController;
  final LocationService _locationService;
  final GetDriverProfileUseCase _getDriverProfileUseCase;
  final SharedPreferences _prefs;
  final GetVehicleUseCase _getVehicleUseCase;
  final ActiveOrderFirestoreService _activeOrderFirestoreService;

  AcceptOrderUseCase(
    this._startOrderUseCase,
    this._firebaseService,
    this._sessionController,
    this._locationService,
    this._getDriverProfileUseCase,
    this._prefs,
    this._getVehicleUseCase,
    this._activeOrderFirestoreService,
  );

  Future<BaseResponse<OrderEntity>> call(OrderEntity order) async {
    // ── Step 1: Pre-validate GPS ──────────────────────────────────
    final position = await _locationService.getCurrentLocation();
    if (position == null) {
      return const ErrorResponse(
        errorMessage:
            'Location services are required to accept an order. '
            'Please enable GPS and grant location permissions.',
      );
    }

    // ── Step 2: Pre-validate driver profile ───────────────────────
    var driver = _sessionController.user;
    if (driver == null) {
      final profileResult = await _getDriverProfileUseCase.call();
      if (profileResult is SuccessResponse<DriverEntity>) {
        driver = profileResult.data;
        _sessionController.saveUser(driver);
      }
    }
    if (driver == null) {
      return const ErrorResponse(
        errorMessage:
            'Driver profile not found. '
            'Please log in again to accept orders.',
      );
    }

    // ── Step 3: Fetch Firebase user data ──────────────────────────
    final userDataFirestore = await _firebaseService.getUserDataByUserId(
      order.user?.id ?? "",
    );

    // ── Step 4: Call startOrder API (point of no return) ──────────
    final response = await _startOrderUseCase(order.id);

    if (response is SuccessResponse<OrderEntity>) {
      // ── Step 5: Post-API operations (wrapped in try-catch) ─────
      try {
        String? vehicleImage;
        final vehicleResult = await _getVehicleUseCase.call(driver.vehicleType);
        if (vehicleResult is SuccessResponse<VehicleEntity>) {
          vehicleImage = vehicleResult.data.image;
        }

        final trackingModel = OrderTrackingFirebaseModel(
          userData: {
            'userId': userDataFirestore?['userId'] ?? order.user?.id,
            'deviceToken': userDataFirestore?['deviceToken'],
            'userName': order.user?.fullName,
            'userPhone': order.user?.phone,
            'userImage': order.user?.photo,
          },
          orderData: {
            'orderId': order.id,
            'orderNumber': order.orderNumber,
            'totalPrice': order.totalPrice,
            'paymentType': order.paymentType,
            'shippingAddress': {
              'street': order.shippingAddress?.street,
              'city': order.shippingAddress?.city,
              'location': {
                'lat': double.tryParse(order.shippingAddress?.lat ?? ''),
                'long': double.tryParse(order.shippingAddress?.long ?? ''),
              },
            },
          },
          driverData: {
            'driverId': driver.id,
            'driverName': "${driver.firstName} ${driver.lastName}",
            'driverPhone': driver.phone,
            'vehicleNumber': driver.vehicleNumber,
            'driverToken': await PushNotificationService.getDeviceTokenAsync(),
            'vehicleImage': vehicleImage,
          },
          trackingLocation: {
            'lat': position.latitude,
            'long': position.longitude,
          },
          storeData: {
            'storeName': order.store?.name,
            'storeAddress': order.store?.address,
            'storePhone': order.store?.phoneNumber,
            'storeImage': order.store?.image,
          },
          orderItems: (order.orderItems ?? [])
              .map(
                (item) => {
                  'productId': item.product?.id,
                  'productTitle': item.product?.title,
                  'productQuantity': item.quantity,
                  'productPrice': item.price,
                  'productImage': item.product?.imgCover,
                },
              )
              .toList(),
          status: 'accepted',
          updatedAt: DateTime.now(),
        );

        await _firebaseService.uploadTrackingOrder(
          order.id,
          trackingModel.toJson(),
        );

        await _prefs.setString(ApiConstants.currentOrderIdKey, order.id);

        final driverId = driver.id;
        if (driverId.isNotEmpty) {
          await _prefs.setString(ApiConstants.driverIdKey, driverId);
          await _activeOrderFirestoreService.saveActiveOrder(
            driverId,
            order.id,
          );
        }
      } catch (_) {
        // Post-API ops failed, but the order IS accepted server-side.
        // Swallow the error so the UI reflects the successful accept.
      }
    }

    return response;
  }
}
