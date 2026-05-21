import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../view_model/home_view_model.dart';

class HeroFoodIcon extends StatelessWidget {
  const HeroFoodIcon({
    required this.item,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final HeroFoodItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isActive ? 1.08 : 0.92,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            width: isActive ? 72 : 62,
            height: isActive ? 72 : 62,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.blackOverlay.withValues(alpha: 0.28),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? AppColors.splashTextYellow
                    : AppColors.splashTextPrimary.withValues(alpha: 0.18),
                width: isActive ? 2 : 1,
              ),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: AppColors.splashTextYellow.withValues(alpha: 0.25),
                    blurRadius: 24,
                    spreadRadius: 1,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    item.iconImage,
                    semanticLabel: item.title,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
