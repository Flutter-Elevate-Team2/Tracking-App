import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/extension/string_extension.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';

class AddressInfoRow extends StatelessWidget {
  final String label;
  final OrderEntity order;
  final StoreEntity store;
  final bool isUser;

  const AddressInfoRow({
    super.key,
    required this.order,
    required this.store,
    required this.label,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderTrackingFirebaseModel?>(
      future: isUser && order.id != null
          ? getIt<FirebaseOrderService>().getTrackingOrderById(order.id!)
          : null,
      builder: (context, snapshot) {
        String imageUrl;
        String name;
        String address;

        if (isUser) {
          final user = order.user;
          final trackingData = snapshot.data;

          String? firestoreImage = trackingData?.userData['userImage'];
          if (firestoreImage != null && firestoreImage.isNotEmpty) {
            imageUrl = firestoreImage.toImageUrl;
          } else {
            imageUrl = (user?.photo ?? '').isEmpty
                ? 'https://i.pravatar.cc/150?u=${order.id}'
                : user!.photo!.toImageUrl;
          }

          name =
              trackingData?.userData['userName'] ??
              user?.firstName ??
              context.l10n.sampleUserName;
          address = order.updatedAt ?? context.l10n.sampleAddress;
        } else {
          imageUrl = (store.image ?? '').isEmpty
              ? 'https://flower.elevateegy.com/placeholder.png'
              : store.image!.toImageUrl;

          name = store.name ?? context.l10n.floweryStore;
          address = store.address ?? context.l10n.sampleAddress;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.gray),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGray),
              ),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 20,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.gray,
                      child: const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=${order.id}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.gray,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                address,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
