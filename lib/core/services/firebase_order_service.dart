import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';

@singleton
class FirebaseOrderService {
  final FirebaseFirestore _firestore;

  FirebaseOrderService(this._firestore);

  Future<Map<String, dynamic>?> getUserDataByOrderId(String orderId) async {
    try {
      final doc = await _firestore.collection('order_data').doc(orderId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Uploads or updates the tracking information for an active order.
  Future<void> uploadTrackingOrder(
    String orderId,
    Map<String, dynamic> trackingData,
  ) async {
    await _firestore
        .collection('active_orders')
        .doc(orderId)
        .set(trackingData, SetOptions(merge: true));
  }

  Future<OrderTrackingFirebaseModel?> getTrackingOrderById(
    String orderId,
  ) async {
    final doc = await _firestore.collection('active_orders').doc(orderId).get();
    if (!doc.exists) return null;
    return OrderTrackingFirebaseModel.fromJson(doc.data()!);
  }

  Future<Map<String, dynamic>?> getUserDataByUserId(String userId) async {
    try {
      final doc = await _firestore.collection('user_data').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateOrderLocation(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('active_orders').doc(orderId).update(data);
  }
  Future<void> updateDriverTokenInActiveOrder(String orderId, String newToken) async {
    try {
      await _firestore.collection('active_orders').doc(orderId).update({
        'driverData.driverToken': newToken,
      });
    } catch (e) {
      debugPrint("Failed to update driver token in active order: $e");
    }
  }
}
