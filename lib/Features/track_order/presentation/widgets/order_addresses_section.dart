import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/address_section.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/launch.dart';

class OrderAddressesSection extends StatelessWidget {
  final OrderTrackingEntity order;

  const OrderAddressesSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddressSection(
          label: context.l10n.pickupAddress,
          name: order.store.storeName,
          address: order.store.storeAddress,
          imagePath: order.store.storeImage,
          onPhoneTap: () => launchPhone(order.store.storePhone),
          onChatTap: () => launchWhatsApp(order.store.storePhone),
          onAddressTap: () {
            context.push(
              Routes.mapPath,
              extra: {'order': order, 'isPickup': true},
            );
          },
        ),
        AddressSection(
          label: context.l10n.userAddress,
          name: order.user.userName,
          address: order.shippingAddress,
          imagePath: order.user.userImage,
          onPhoneTap: () => launchPhone(order.user.userPhone),
          onChatTap: () => launchWhatsApp(order.user.userPhone),
          onAddressTap: () {
            context.push(
              Routes.mapPath,
              extra: {'order': order, 'isPickup': false},
            );
          },
        ),
      ],
    );
  }
}
