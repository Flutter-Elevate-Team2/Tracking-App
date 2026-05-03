import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? disabledColor;

  const CustomButton({
    required this.title,
    required this.onPressed,
    super.key,
    this.backgroundColor ,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                if (states.contains(WidgetState.disabled)) {
                  if (disabledColor != null) {
                    return disabledColor!;
                  }
                }
                return backgroundColor!;
              },
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          child: Text(title, style: TextStyle(fontSize: 16 , color: AppColors.white)),
        ),
      ),
    );
  }
}
