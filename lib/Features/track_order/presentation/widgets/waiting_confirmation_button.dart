import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class WaitingConfirmationButton extends StatelessWidget {
  const WaitingConfirmationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white[70],
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              context.l10n.waitingCustomerConfirmation,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
