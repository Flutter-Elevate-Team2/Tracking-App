import 'package:tracking_app/Features/track_order/data/model/complete_order_response/complete_order_response.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';

extension CompleteOrderMapper on CompleteOrderResponse? {
  CompleteOrderEntity toEntity() {
    return CompleteOrderEntity(
      message: this?.message ?? 'تم إنهاء الطلب',
      orderId: this?.orders?.id ?? '',
      orderNumber: this?.orders?.orderNumber ?? '',
      state: this?.orders?.state ?? '',
      totalPrice: this?.orders?.totalPrice ?? 0,
      paymentType: this?.orders?.paymentType ?? 'cash',
    );
  }
}
