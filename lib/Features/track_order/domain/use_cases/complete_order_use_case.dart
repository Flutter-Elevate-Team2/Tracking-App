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
  final FirebaseFirestore _firestore; // أضفت ده
  final SharedPreferences _prefs;      // أضفت ده

  CompleteOrderUseCase(
      this._trackOrderRepoContract,
      this._activeOrderFirestoreService,
      this._firestore, // تمرير من برا
      this._prefs,     // تمرير من برا
      );

  Future<BaseResponse<CompleteOrderEntity>> call(String orderId) async {
    final response = await _trackOrderRepoContract.changeOrderState(orderId);

    if (response is SuccessResponse<CompleteOrderEntity>) {
      try {
        // نستخدم _firestore الممررة بدل الـ instance الثابتة
        await _firestore.collection('active_orders').doc(orderId).update({
          'status': 'completed',
          'updatedAt': FieldValue.serverTimestamp(),
        });

        final driverId = _prefs.getString(ApiConstants.driverIdKey) ?? '';

        if (driverId.isNotEmpty) {
          await _activeOrderFirestoreService.clearActiveOrder(driverId);
        }
        await _prefs.remove(ApiConstants.currentOrderIdKey);
      } catch (e) {
        debugPrint("Failed to sync Firebase or Local Storage: $e");
      }
    }
    return response;
  }
}
