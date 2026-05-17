import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ActiveOrderFirestoreService {
  final FirebaseFirestore _firestore;

  ActiveOrderFirestoreService(this._firestore);

  Future<void> saveActiveOrder(String driverId, String orderId) async {
    await _firestore.collection('active_orders').doc(driverId).set({
      'orderId': orderId,
    });
  }

  Future<String?> getActiveOrder(String driverId) async {
    try {
      // 1. Force server fetch to bypass stale cache
      final doc = await _firestore
          .collection('active_orders')
          .doc(driverId)
          .get(const GetOptions(source: Source.server));

      if (doc.exists) {
        return doc.data()?['orderId'] as String?;
      }
      return null;
    } catch (e) {
      // 2. Fallback to default behavior if server fetch fails (e.g., offline)
      debugPrint("Server fetch failed, falling back to cache: $e");
      final fallbackDoc = await _firestore
          .collection('active_orders')
          .doc(driverId)
          .get();

      if (fallbackDoc.exists) {
        return fallbackDoc.data()?['orderId'] as String?;
      }
      return null;
    }
  }

  Future<void> clearActiveOrder(String driverId) async {
    await _firestore.collection('active_orders').doc(driverId).delete();
  }
}
