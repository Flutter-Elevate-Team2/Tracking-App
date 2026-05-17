import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/address_info_row.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/extension/string_extension.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.white[10],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${context.l10n.flowerOrder} ${order.orderNumber ?? ''}",
              style: AppTheme.getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            AddressInfoRow(
              label: context.l10n.pickupAddress,
              name: order.store?.name ?? context.l10n.floweryStore,
              address: order.store?.address ?? context.l10n.sampleAddress,
              leading: CachedNetworkImage(
                imageUrl: (order.store?.image ?? '').isEmpty
                    ? 'https://flower.elevateegy.com/placeholder.png'
                    : order.store!.image!.toImageUrl,
                imageBuilder: (context, imageProvider) =>
                    CircleAvatar(radius: 20, backgroundImage: imageProvider),
                placeholder: (context, url) => const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.mainColor,
                  child: const Icon(Icons.store, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AddressInfoRow(
              label: context.l10n.userAddress,
              name: order.user?.fullName ?? context.l10n.sampleUserName,
              address:
                  order.shippingAddress?.street ?? context.l10n.sampleAddress,
              leading: CachedNetworkImage(
                imageUrl: (order.user?.photo ?? '').isEmpty
                    ? 'https://i.pravatar.cc/150?u=${order.id}'
                    : order.user!.photo.toImageUrl,
                imageBuilder: (context, imageProvider) =>
                    CircleAvatar(radius: 20, backgroundImage: imageProvider),
                placeholder: (context, url) => const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=${order.id}',
                  ),
                  // child: Icon(Icons.person, color: AppColors.gray),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '${context.l10n.egp} ${order.totalPrice ?? 0}',
                  style: AppTheme.getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: BlocBuilder<HomeViewModel, HomeState>(
                    builder: (context, state) {
                      final isAccepting = state.acceptingOrderId == order.id;

                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context.read<HomeViewModel>().doIntent(
                                  RejectOrderEvent(order.id),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.mainColor,
                                side: BorderSide(color: AppColors.mainColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                context.l10n.reject,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isAccepting
                                  ? null
                                  : () {
                                      context.read<HomeViewModel>().doIntent(
                                        AcceptOrderEvent(order),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainColor,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: isAccepting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      context.l10n.accept,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
