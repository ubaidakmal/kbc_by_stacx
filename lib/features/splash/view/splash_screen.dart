import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_spacing.dart';
import '../widgets/splash_cooking_pot.dart';
import '../widgets/splash_firewood_animation.dart';
import '../widgets/splash_loading_text.dart';
import '../widgets/splash_smoke_animation.dart';
import '../widgets/splash_sparks_animation.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final compactHeight = height < 680;
          final horizontalPadding = width < 420 ? 20.0 : 32.0;
          final contentWidth = math.min(
            width - (horizontalPadding * 2),
            AppConstants.maxContentWidth,
          );
          final sceneHeight = (height * (compactHeight ? 0.39 : 0.48))
              .clamp(compactHeight ? 224.0 : 250.0, 430.0)
              .toDouble();
          final sceneWidth = math.min(contentWidth, 520.0);
          final fireSize = (sceneWidth * 0.66).clamp(200.0, 350.0).toDouble();
          final potWidth = (sceneWidth * 0.54).clamp(158.0, 284.0).toDouble();
          final headlineSize = (width * 0.08)
              .clamp(compactHeight ? 24.0 : 27.0, 42.0)
              .toDouble();

          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                const _SplashBackgroundBase(),
                const _WarmGlowLayer(),
                SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppConstants.maxContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: compactHeight ? 10 : 22,
                        ),
                        child: Column(
                          children: [
                            const _BrandPill()
                                .animate()
                                .fadeIn(duration: 650.ms)
                                .slideY(begin: -0.18, end: 0),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _CookingScene(
                                          sceneWidth: sceneWidth,
                                          sceneHeight: sceneHeight,
                                          fireSize: fireSize,
                                          potWidth: potWidth,
                                        )
                                        .animate()
                                        .fadeIn(duration: 900.ms, delay: 100.ms)
                                        .scale(
                                          begin: const Offset(0.96, 0.96),
                                          end: const Offset(1, 1),
                                        ),
                                    VerticalGap(compactHeight ? 10 : 18),
                                    _GradientHeadline(fontSize: headlineSize)
                                        .animate()
                                        .fadeIn(duration: 720.ms, delay: 280.ms)
                                        .slideY(begin: 0.18, end: 0),
                                    const SizedBox(height: 10),
                                    ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 500,
                                          ),
                                          child: _SplashSubtitle(
                                            fontSize:
                                                compactHeight || width < 390
                                                ? 13
                                                : 16,
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(duration: 720.ms, delay: 420.ms)
                                        .slideY(begin: 0.2, end: 0),
                                  ],
                                ),
                              ),
                            ),
                            const SplashLoadingText().animate().fadeIn(
                              duration: 650.ms,
                              delay: 560.ms,
                            ),
                            SizedBox(height: compactHeight ? 8 : 12),
                            Text(
                              AppConstants.locationLabel.toUpperCase(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.splashTextSoft,
                                letterSpacing: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SplashBackgroundBase extends StatelessWidget {
  const _SplashBackgroundBase();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
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
            stops: [0.0, 0.46, 1.0],
          ),
        ),
      ),
    );
  }
}

class _WarmGlowLayer extends StatelessWidget {
  const _WarmGlowLayer();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.2),
                  radius: 0.74,
                  colors: [
                    AppColors.splashWarmOrangeGlow.withValues(alpha: 0.2),
                    AppColors.splashFireGlow.withValues(alpha: 0.13),
                    AppColors.splashDeepRed.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.42, 1.0],
                ),
              ),
              child: const SizedBox.expand(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.88, 0.86),
                  radius: 0.58,
                  colors: [
                    AppColors.splashYellowGlow.withValues(alpha: 0.13),
                    AppColors.splashWarmOrangeGlow.withValues(alpha: 0.06),
                    AppColors.splashDeepRed.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.42, 1.0],
                ),
              ),
              child: const SizedBox.expand(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.86, -0.72),
                  radius: 0.7,
                  colors: [
                    AppColors.splashMaroon.withValues(alpha: 0.24),
                    AppColors.splashFireGlow.withValues(alpha: 0.06),
                    AppColors.splashDeepRed.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.44, 1.0],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandPill extends StatelessWidget {
  const _BrandPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.blackOverlay.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primaryYellow.withValues(alpha: 0.34),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.fireOrange.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Text(
          AppConstants.brandName,
          textAlign: TextAlign.center,
          style: AppTextStyles.label.copyWith(
            color: AppColors.splashTextPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}

class _GradientHeadline extends StatelessWidget {
  const _GradientHeadline({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.headingLarge.copyWith(
      fontSize: fontSize,
      color: AppColors.splashTextPrimary,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Cooking the ', style: baseStyle),
          TextSpan(
            text: 'next hot ',
            style: baseStyle.copyWith(color: AppColors.splashTextYellow),
          ),
          TextSpan(
            text: 'batch',
            style: baseStyle.copyWith(
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    AppColors.splashTextYellow,
                    AppColors.splashTextOrange,
                    AppColors.splashTextRed,
                  ],
                ).createShader(const Rect.fromLTWH(0, 0, 150, 48)),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _SplashSubtitle extends StatelessWidget {
  const _SplashSubtitle({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.body.copyWith(
      fontSize: fontSize,
      color: AppColors.splashTextMuted,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Fresh Pakistani and Indian style biryani, fired up for ',
            style: style,
          ),
          TextSpan(
            text: 'Sugar Land',
            style: style.copyWith(color: AppColors.splashTextPrimary),
          ),
          TextSpan(text: '.', style: style),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _CookingScene extends StatelessWidget {
  const _CookingScene({
    required this.sceneWidth,
    required this.sceneHeight,
    required this.fireSize,
    required this.potWidth,
  });

  final double sceneWidth;
  final double sceneHeight;
  final double fireSize;
  final double potWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sceneWidth,
      height: sceneHeight,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [

          Positioned.fill(child: SplashSparksAnimation()),
          Positioned(
            bottom: sceneHeight * 0.00,
            child: SplashFirewoodAnimation(size: fireSize),
          ),
          Positioned(
            top: sceneHeight * 0.06,
            child: SplashSmokeAnimation(
              width: potWidth * 0.92,
              height: sceneHeight * 0.46,
            ),
          ),
          Positioned(
            bottom: sceneHeight * 0.11,
            child: SplashCookingPot(width: potWidth),
          ),
        ],
      ),
    );
  }
}
