import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.controller,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.cream),
      cursorColor: AppColors.primaryYellow,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.cream.withValues(alpha: 0.56),
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: AppColors.primaryYellow),
        filled: true,
        fillColor: AppColors.maroon,
        enabledBorder: _border(AppColors.primaryYellow.withValues(alpha: 0.18)),
        focusedBorder: _border(AppColors.primaryYellow),
        border: _border(AppColors.primaryYellow.withValues(alpha: 0.18)),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}
