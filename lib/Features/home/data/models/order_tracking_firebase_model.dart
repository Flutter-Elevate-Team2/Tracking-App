import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingFirebaseModel {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> orderData;
  final Map<String, dynamic> driverData;
  final Map<String, dynamic> trackingLocation;
  final Map<String, dynamic> storeData;
  final List<Map<String, dynamic>> orderItems;
  final String status;
  final DateTime? updatedAt;

  OrderTrackingFirebaseModel({
    required this.userData,
    required this.orderData,
    required this.driverData,
    required this.trackingLocation,
    required this.storeData,
    required this.orderItems,
    required this.status,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userData': userData,
      'orderData': orderData,
      'driverData': driverData,
      'trackingLocation': trackingLocation,
      'storeData': storeData,
      'orderItems': orderItems,
      'status': status,
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory OrderTrackingFirebaseModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingFirebaseModel(
      userData: json['userData'] as Map<String, dynamic>? ?? {},
      orderData: json['orderData'] as Map<String, dynamic>? ?? {},
      driverData: json['driverData'] as Map<String, dynamic>? ?? {},
      trackingLocation: json['trackingLocation'] as Map<String, dynamic>? ?? {},
      status: json['status'] as String? ?? 'accepted',
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
      orderItems:
          (json['orderItems'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      storeData: json['storeData'] as Map<String, dynamic>? ?? {},
    );
  }
}
