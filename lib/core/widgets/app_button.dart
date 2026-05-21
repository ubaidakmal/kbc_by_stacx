import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label, style: AppTextStyles.button)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.darkRed),
              const SizedBox(width: 8),
              Flexible(child: Text(label, style: AppTextStyles.button)),
            ],
          );

    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: AppColors.darkRed,
        disabledBackgroundColor: AppColors.maroon,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: child,
    );

    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
