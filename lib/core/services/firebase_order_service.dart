import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseOrderService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  /// Gets user data (userId, deviceToken) from Firestore based on orderId.
  /// This assumes the commerce app has uploaded the order info to the 'order_data' collection.
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
}
