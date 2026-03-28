import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ThirdPartyModule {
  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @singleton
  FlutterLocalNotificationsPlugin get localNotifications =>
      FlutterLocalNotificationsPlugin();

  @singleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;
}
