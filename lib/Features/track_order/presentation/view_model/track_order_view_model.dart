import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_directions_use_case.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_order_details_use_case.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/track_order_use_case.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/location_service.dart';

@injectable
class OrderStatusViewModel extends Cubit<TrackOrderStatusState> {
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final LocationService _locationService;
  final FirebaseOrderService _firebaseService;
  final GetDirectionsUseCase _getDirectionsUseCase;
  final ActiveOrderFirestoreService _activeOrderFirestoreService;

  StreamSubscription<Position>? _locationSubscription;

  OrderStatusViewModel(
    this._updateOrderStatusUseCase,
    this._getOrderDetailsUseCase,
    this._locationService,
    this._firebaseService,
    this._getDirectionsUseCase,
    this._activeOrderFirestoreService,
  ) : super(const TrackOrderStatusState());

  void doIntent(BuildContext context, TrackOrderStatusEvent event) {
    switch (event) {
      case FetchOrderDetailsEvent():
        _fetchOrderDetails(event.orderId);
        break;
      case UpdateOrderStatusEvent():
        _updateStatus(
          context,
          orderId: event.orderId,
          status: event.status,
          userToken: event.userToken,
          title: event.title,
        );
        break;
    }
  }

  Future<void> _fetchOrderDetails(String orderId) async {
    if (state.orderState?.data == null) {
      emit(state.copyWith(orderState: const BaseState(isLoading: true)));
    } else {
      emit(
        state.copyWith(orderState: state.orderState?.copyWith(isLoading: true)),
      );
    }
    try {
      final response = await _getOrderDetailsUseCase(orderId);

      if (response != null) {
        emit(
          state.copyWith(
            orderState: BaseState(isLoading: false, data: response),
          ),
        );
        startTracking(orderId);
      } else {
        emit(
          state.copyWith(
            orderState: const BaseState(
              isLoading: false,
              errorMessage: "Order Not Found",
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          orderState: BaseState(isLoading: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  Future<void> _updateStatus(
    BuildContext context, {
    required String orderId,
    required OrderStatus status,
    required String userToken,
    required String title,
  }) async {
    emit(state.copyWith(updateStatusState: const BaseState(isLoading: true)));

    try {
      await _updateOrderStatusUseCase(
        title: title,
        orderId: orderId,
        status: status,
        userToken: userToken,
        body: status.getNotificationBody(context),
        userId: state.orderState?.data?.user.userId ?? '',
      );

      if (status == OrderStatus.accepted) {
        final prefs = await SharedPreferences.getInstance();
        final driverId = prefs.getString(ApiConstants.driverIdKey) ?? '';
        if (driverId.isNotEmpty) {
          await _activeOrderFirestoreService.saveActiveOrder(driverId, orderId);
        }
      } else if (status == OrderStatus.delivered) {
        _locationSubscription?.cancel();
      } 

      emit(
        state.copyWith(updateStatusState: const BaseState(isLoading: false)),
      );
      _fetchOrderDetails(orderId);
    } catch (e) {
      emit(
        state.copyWith(
          updateStatusState: BaseState(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Position _createPosition(double lat, double lng) {
    return Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  // 🌟🌟 التعديل هنا: الدالة بقت async ومستنية الصلاحيات 🌟🌟
  Future<void> startTracking(String orderId) async {
    final order = state.orderState?.data;

    if (order != null) {
      final initialPos = _createPosition(
        order.trackingLocation.lat.toDouble(),
        order.trackingLocation.long.toDouble(),
      );
      emit(state.copyWith(currentDriverPosition: initialPos));
      _updateRoute(initialPos);
    }

    // 🌟 بنستنى السواق يوافق على الصلاحيات براحته
    final pos = await _locationService.getCurrentLocation();
    
    // لو قفل الشاشة أو التطبيق نخرج بأمان
    if (isClosed) return;

    if (pos != null) {
      emit(state.copyWith(currentDriverPosition: pos));
      _updateRoute(pos);

      _locationSubscription?.cancel();
      _locationSubscription = _locationService.getLocationStream().listen(
        (position) {
          if (!isClosed) {
            _firebaseService.updateOrderLocation(orderId, {
              'trackingLocation': {
                'lat': position.latitude,
                'long': position.longitude,
              },
              'updatedAt': DateTime.now().toIso8601String(),
            });
            emit(state.copyWith(currentDriverPosition: position));
            _updateRoute(position);
          }
        },
        onError: (error) {
          debugPrint("Location Stream Error: $error");
        },
      );
    }
  }

  void changeTarget(bool showPickupFirst) {
    emit(state.copyWith(showPickup: showPickupFirst));

    if (state.currentDriverPosition != null) {
      _updateRoute(state.currentDriverPosition!);
    }
  }

  Future<void> _updateRoute(Position currentPos) async {
    final order = state.orderState?.data;
    if (order == null) return;

    final targetLat = state.showPickup
        ? order.store.storeLat
        : order.userLocationEntity.lat;
    final targetLong = state.showPickup
        ? order.store.storeLong
        : order.userLocationEntity.long;

    try {
      final route = await _getDirectionsUseCase(
        mapbox.Position(currentPos.longitude, currentPos.latitude),
        mapbox.Position(targetLong.toDouble(), targetLat.toDouble()),
      );

      if (route.isNotEmpty) {
        emit(state.copyWith(routePoints: List.from(route)));
      }
    } catch (e) {
      debugPrint("Route Error: $e");
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}