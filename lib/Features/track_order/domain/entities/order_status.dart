import 'package:flutter/material.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

enum OrderStatus {
  accepted('accepted'),
  arrivedPickup('arrived_pickup'),
  startDeliver('start_deliver'),
  arrivedUser('arrived_user'),
  delivered('delivered');

  final String firebaseValue;
  const OrderStatus(this.firebaseValue);

  String getDisplayName(BuildContext context) {
    switch (this) {
      case OrderStatus.accepted:
        return context.l10n.accepted;
      case OrderStatus.arrivedPickup:
        return context.l10n.picked;
      case OrderStatus.startDeliver:
        return context.l10n.outForDelivery;
      case OrderStatus.arrivedUser:
        return context.l10n.arrived;
      case OrderStatus.delivered:
        return context.l10n.delivered;
    }
  }

  String getNotificationBody(BuildContext context) {
    switch (this) {
      case OrderStatus.accepted:
        return context.l10n.orderAcceptedBody;
      case OrderStatus.arrivedPickup:
        return context.l10n.notificationArrivedPickup;
      case OrderStatus.startDeliver:
        return context.l10n.notificationStartDeliver;
      case OrderStatus.arrivedUser:
        return context.l10n.notificationArrivedUser;
      case OrderStatus.delivered:
        return context.l10n.notificationDelivered;
    }
  }

  String getButtonText(BuildContext context) {
    switch (this) {
      case OrderStatus.accepted:
        return context.l10n.arrivedAtPickupPointButton;
      case OrderStatus.arrivedPickup:
        return context.l10n.startDeliverButton;
      case OrderStatus.startDeliver:
        return context.l10n.arrivedToUserButton;
      case OrderStatus.arrivedUser:
        return context.l10n.deliveredToUser;
      case OrderStatus.delivered:
        return context.l10n.deliveredToUser;
    }
  }

  OrderStatus? get next {
    final currentIndex = OrderStatus.values.indexOf(this);
    if (currentIndex < OrderStatus.values.length - 1) {
      return OrderStatus.values[currentIndex + 1];
    }
    return null;
  }

  static OrderStatus fromFirebase(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.firebaseValue == value,
      orElse: () => OrderStatus.accepted,
    );
  }
}
