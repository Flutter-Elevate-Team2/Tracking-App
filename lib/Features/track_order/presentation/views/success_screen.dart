import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/widget/custom_button.dart';
import 'package:tracking_app/gen/assets.gen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  Assets.lottie.success,
                  height: MediaQuery.of(context).size.height * 0.45,
                  repeat: true,
                ),

                Text(
                  context.l10n.thankYou,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  context.l10n.orderDeliveredSuccessfully,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.secondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                CustomButton(
                  title: context.l10n.done,
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('show_success_screen');

                    if (context.mounted) {
                      // Trigger refresh of the singleton ViewModel
                      getIt<MyOrdersViewModel>().doIntent(
                        GetDriverOrdersEvent(),
                      );
                      // Navigate to My Orders directly
                      context.goNamed(Routes.ordersName);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
