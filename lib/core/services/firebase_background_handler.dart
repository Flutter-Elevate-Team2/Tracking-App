import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (message.data['action'] == 'customer_confirmed') {
    final orderId = message.data['orderId'];

    if (orderId != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();

        final driverId = prefs.getString(ApiConstants.driverIdKey) ?? '';
        if (driverId.isNotEmpty) {
          final firestore = FirebaseFirestore.instance;

          await firestore.collection('active_orders').doc(driverId).delete();

          try {
            await firestore.collection('active_orders').doc(orderId).update({
              'status': 'completed',
              'updatedAt': FieldValue.serverTimestamp(),
            });
          } catch (_) {}
        }

        await prefs.remove(ApiConstants.currentOrderIdKey);
        await prefs.setBool('show_success_screen', true);
        debugPrint("✅ Active order cleared for driver after background completion");

        String? token = prefs.getString(ApiConstants.tokenKey);
        final url = Uri.parse(
          'https://flower.elevateegy.com/api/v1/orders/state/$orderId',
        );
        final response = await http.put(
          url,
          body: jsonEncode({"state": "completed"}),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );

        debugPrint("Background API Status: ${response.statusCode}");
      } catch (e) {
        debugPrint("❌ Background FCM Error: $e");
      }
    }
  }
}
