import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../view_model/home_view_model.dart';

class HeroDishShowcase extends StatefulWidget {
  const HeroDishShowcase({
    required this.animationDelay,
    required this.animationDuration,
    this.compact = false,
    super.key,
  });

  final Duration animationDelay;
  final Duration animationDuration;
  final bool compact;

  @override
  State<HeroDishShowcase> createState() => _HeroDishShowcaseState();
}

class _HeroDishShowcaseState extends State<HeroDishShowcase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDish = context.watch<HomeViewModel>().selectedDish;
    final dishSize = widget.compact ? 260.0 : 390.0;

    return SizedBox(
          width: widget.compact ? 330 : 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final wave = Curves.easeInOut.transform(
                    _floatController.value,
                  );
                  return Transform.translate(
                    offset: Offset(0, math.sin(wave * math.pi) * -10),
                    child: child,
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: dishSize * 0.92,
                      height: dishSize * 0.92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.splashWarmOrangeGlow.withValues(
                              alpha: 0.24,
                            ),
                            AppColors.splashFireGlow.withValues(alpha: 0.12),
                            AppColors.splashDeepRed.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 520),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final offset = Tween<Offset>(
                          begin: const Offset(0.34, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offset,
                            child: child,
                          ),
                        );
                      },
                      child: Image.asset(
                        selectedDish.dishImage,
                        key: ValueKey(selectedDish.title),
                        width: dishSize,
                        height: dishSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                child: Column(
                  key: ValueKey(selectedDish.title),
                  children: [
                    Text(
                      selectedDish.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.splashTextPrimary,
                        fontSize: widget.compact ? 18 : 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selectedDish.shortDescription,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.splashTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          delay: widget.animationDelay,
          duration: widget.animationDuration,
          curve: Curves.easeOutCubic,
        )
        .slideX(
          begin: 0.48,
          end: 0,
          delay: widget.animationDelay,
          duration: widget.animationDuration,
          curve: Curves.easeOutCubic,
        );
  }
}
