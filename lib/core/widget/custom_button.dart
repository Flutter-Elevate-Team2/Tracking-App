import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color?  backgroundColor ;
  final Color? foregroundColor ;

  const CustomButton({
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor ,
    super.key,
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
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            backgroundColor: backgroundColor,
            foregroundColor:foregroundColor,
            side: backgroundColor == AppColors.white
                ? BorderSide(color: AppColors.gray)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Text(title, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
