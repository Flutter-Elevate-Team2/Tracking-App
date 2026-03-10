import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/repo/track_order_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';

@injectable
class CompleteOrderUseCase {
  final TrackOrderRepoContract _trackOrderRepoContract;
  final ActiveOrderFirestoreService _activeOrderFirestoreService;

  CompleteOrderUseCase(
    this._trackOrderRepoContract,
    this._activeOrderFirestoreService,
  );
  Future<BaseResponse<CompleteOrderEntity>> call(String orderId) async {
    final response = await _trackOrderRepoContract.changeOrderState(orderId);

    if (response is SuccessResponse<CompleteOrderEntity>) {
      try {
        await FirebaseFirestore.instance
            .collection('active_orders')
            .doc(orderId)
            .update({
          'status': 'completed',
          'updatedAt': FieldValue.serverTimestamp(),
        });

        final prefs = await SharedPreferences.getInstance();
        final driverId = prefs.getString(ApiConstants.driverIdKey) ?? '';

        if (driverId.isNotEmpty) {
          await _activeOrderFirestoreService.clearActiveOrder(driverId);
        }
        await prefs.remove(ApiConstants.currentOrderIdKey);

      } catch (e) {
        debugPrint("Failed to sync Firebase or Local Storage after API success: $e");
      }
    }

    return response;
  }
}
