import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/address_section.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/launch.dart';

class MapBottomSheet extends StatelessWidget {
  const MapBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BlocBuilder<OrderStatusViewModel, TrackOrderStatusState>(
        builder: (context, state) {
          final order = state.orderState?.data;
          if (order == null) return const SizedBox.shrink();

          final storeCard = _buildAddressItem(
            context,
            isStore: true,
            state: state,
          );
          final userCard = _buildAddressItem(
            context,
            isStore: false,
            state: state,
          );

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.lightGray,
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                if (state.showPickup) ...[
                  storeCard,
                  userCard,
                ] else ...[
                  userCard,
                  storeCard,
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressItem(
    BuildContext context, {
    required bool isStore,
    required TrackOrderStatusState state,
  }) {
    final order = state.orderState!.data!;
    return GestureDetector(
      onTap: () => context.read<OrderStatusViewModel>().changeTarget(isStore),
      child: AddressSection(
        label: isStore ? context.l10n.pickupAddress : context.l10n.userAddress,
        name: isStore ? order.store.storeName : order.user.userName,
        address: isStore ? order.store.storeAddress : order.shippingAddress,
        imagePath: isStore ? order.store.storeImage : order.user.userImage,
        onPhoneTap: () => isStore
            ? launchPhone(order.store.storePhone)
            : launchPhone(order.user.userPhone),
        onChatTap: () => isStore
            ? launchWhatsApp(order.store.storePhone)
            : launchWhatsApp(order.user.userPhone),
      ),
    );
  }
}
