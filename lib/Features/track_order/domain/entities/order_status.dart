import 'package:flutter/material.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

enum OrderStatus {
  accepted('accepted'),
  arrivedPickup('arrived_pickup'),
  startDeliver('start_deliver'),
  arrivedUser('arrived_user'),
  delivered('delivered'),
  completed('completed');

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
      case OrderStatus.completed:
        return context.l10n.delivered;
    }
  }

  String getNotificationTitle(BuildContext context) {
    switch (this) {
      case OrderStatus.accepted:
        return context.l10n.notifAcceptedTitle;
      case OrderStatus.arrivedPickup:
        return context.l10n.notifArrivedPickupTitle;
      case OrderStatus.startDeliver:
        return context.l10n.notifStartDeliverTitle;
      case OrderStatus.arrivedUser:
        return context.l10n.notifArrivedUserTitle;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return context.l10n.notifDeliveredTitle;
    }
  }

  String getNotificationBody(BuildContext context) {
    switch (this) {
      case OrderStatus.accepted:
        return context.l10n.notifAcceptedBody;
      case OrderStatus.arrivedPickup:
        return context.l10n.notifArrivedPickupBody;
      case OrderStatus.startDeliver:
        return context.l10n.notifStartDeliverBody;
      case OrderStatus.arrivedUser:
        return context.l10n.notifArrivedUserBody;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return context.l10n.notifDeliveredBody;
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
      case OrderStatus.completed:
        return context.l10n.deliveredToUser;
    }
  }

  OrderStatus? get next {
    final currentIndex = OrderStatus.values.indexOf(this);
    if (this == OrderStatus.delivered || this == OrderStatus.completed) return null;

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
