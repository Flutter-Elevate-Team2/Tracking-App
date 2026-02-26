enum OrderStatus {
  accepted('accepted'),
  arrivedPickup('arrived_pickup'),
  startDeliver('start_deliver'),
  arrivedUser('arrived_user'),
  delivered('delivered');

  final String firebaseValue;

  const OrderStatus(this.firebaseValue);

  static OrderStatus fromFirebase(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.firebaseValue == value,
      orElse: () => OrderStatus.accepted,
    );
  }
}
