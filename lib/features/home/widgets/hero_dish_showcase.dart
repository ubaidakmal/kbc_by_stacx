import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
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
    final width = widget.compact ? 300.0 : 470.0;
    final height = widget.compact ? 340.0 : 520.0;
    final dishSize = widget.compact ? 300.0 : 480.0;

    return SizedBox(
          width: width,
          height: height,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                left: widget.compact ? 18 : 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.cream.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(
                      widget.compact ? 42 : 58,
                    ),
                    border: Border.all(
                      color: AppColors.splashTextPrimary.withValues(
                        alpha: 0.08,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.splashWarmOrangeGlow.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 70,
                        offset: const Offset(0, 24),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: widget.compact ? -6 : -32,
                child: AnimatedBuilder(
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
                          semanticLabel: selectedDish.title,
                          width: dishSize,
                          height: dishSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
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
