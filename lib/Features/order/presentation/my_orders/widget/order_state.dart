import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class OrderState extends StatelessWidget {
  final String state;
  const OrderState(this.state ,{super.key});

  @override
  Widget build(BuildContext context) {
    if(state == context.l10n.completed.toLowerCase()){
      return Expanded(
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.green,
            ),
            const SizedBox(width: 4),
            Text(
              state,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.green),
            ),
          ],
        ),
      );
    } else if(state == context.l10n.cancelled.toLowerCase()){
      return Expanded(
        child: Row(
          children:  [
            const Icon(
              Icons.cancel_outlined,
              color: AppColors.red,
            ),
            const SizedBox(width: 4),
            Text(
              state,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.red),
            ),
          ],
        ),
      );
    }
    else {
      return Expanded(
        child: Row(
          children:  [
             Icon(
              Icons.local_shipping_outlined,
              color: Colors.yellow,
            ),
            const SizedBox(width: 4),
            Text(
              state,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.yellow),
            ),
          ],
        ),
      );
    }
  }
}
