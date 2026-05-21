import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class HeroBackground extends StatelessWidget {
  const HeroBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.splashBgTop,
                  AppColors.splashBgMid,
                  AppColors.splashBgBottom,
                ],
                stops: [0, 0.48, 1],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.58, 0.18),
                radius: 0.62,
                colors: [
                  AppColors.splashWarmOrangeGlow.withValues(alpha: 0.2),
                  AppColors.splashFireGlow.withValues(alpha: 0.12),
                  AppColors.splashDeepRed.withValues(alpha: 0),
                ],
                stops: const [0, 0.45, 1],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.95, 0.78),
                radius: 0.58,
                colors: [
                  AppColors.splashYellowGlow.withValues(alpha: 0.12),
                  AppColors.splashWarmOrangeGlow.withValues(alpha: 0.05),
                  AppColors.splashDeepRed.withValues(alpha: 0),
                ],
                stops: const [0, 0.44, 1],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.85, -0.72),
                radius: 0.7,
                colors: [
                  AppColors.splashMaroon.withValues(alpha: 0.25),
                  AppColors.splashFireGlow.withValues(alpha: 0.06),
                  AppColors.splashDeepRed.withValues(alpha: 0),
                ],
                stops: const [0, 0.45, 1],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
