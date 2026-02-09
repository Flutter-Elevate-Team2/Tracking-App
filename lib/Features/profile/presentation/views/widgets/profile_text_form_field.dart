import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool isObscure;
  final Widget? trailing;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final String? hintText;

  const ProfileTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.isObscure = false,
    this.trailing,
    this.controller,
    this.validator,
    this.readOnly = false, this.hintText,
  });

  @override
  Widget build(BuildContext context) {
   
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4), 
      borderSide: const BorderSide(
        color: AppColors.gray, 
        width: 1.2,
      ),
    );

    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      obscureText: isObscure,
      readOnly: readOnly,
      validator: validator,
     
      
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[400],
              fontSize: 14,
            ),
        
        floatingLabelBehavior: FloatingLabelBehavior.always,
        
        
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
        
        suffixIcon: trailing,
        
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        
       
        border: borderStyle,         
        enabledBorder: borderStyle,  
        
        focusedBorder: borderStyle.copyWith(
          borderSide:  BorderSide(color: AppColors.mainColor, width: 1.2),
        ),
        
        errorBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}