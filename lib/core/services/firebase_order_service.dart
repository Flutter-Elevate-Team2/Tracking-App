import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> updateOrderLocation(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('active_orders').doc(orderId).update(data);
  }
}
