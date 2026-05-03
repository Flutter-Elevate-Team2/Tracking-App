import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class OrderStepper extends StatelessWidget {
  final int currentStep;
  final bool isLoading;

  const OrderStepper({
    super.key,
    required this.currentStep,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final bool isBeingLoaded = index == currentStep + 1 && isLoading;
        final bool isCompleted = index <= currentStep;

        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.green : AppColors.lightGray,
              borderRadius: BorderRadius.circular(2),
            ),
            child: isBeingLoaded
                ? const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
                  )
                : null,
          ),
        );
      }),
    );
  }
}
