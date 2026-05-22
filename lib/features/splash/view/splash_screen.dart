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

const _brandStart = Duration.zero;
const _brandDuration = Duration(milliseconds: 650);
const _headlineStart = Duration(milliseconds: 780);
const _headlineDuration = Duration(milliseconds: 780);
const _subtitleStart = Duration(milliseconds: 1660);
const _subtitleDuration = Duration(milliseconds: 650);
const _fireStart = Duration(milliseconds: 2410);
const _fireDuration = Duration(milliseconds: 760);
const _potStart = Duration(milliseconds: 3270);
const _potDuration = Duration(milliseconds: 780);
const _loadingStart = Duration(milliseconds: 4180);
const _loadingDuration = Duration(milliseconds: 650);

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final phoneWidth = width < 430;
          final compactHeight = height < 680;
          final shortScreen = height < 820;
          final horizontalPadding = width < 420 ? 20.0 : 32.0;
          final contentWidth = math.min(
            width - (horizontalPadding * 2),
            AppConstants.maxContentWidth,
          );
          final sceneHeight =
              (height *
                      (compactHeight
                          ? 0.36
                          : (shortScreen ? 0.38 : (phoneWidth ? 0.34 : 0.48))))
                  .clamp(
                    compactHeight
                        ? 196.0
                        : (shortScreen ? 280.0 : (phoneWidth ? 280.0 : 250.0)),
                    shortScreen ? 360.0 : 430.0,
                  )
                  .toDouble();
          final sceneWidth = math.min(contentWidth, 520.0);
          final fireSize = (sceneWidth * 0.66).clamp(200.0, 350.0).toDouble();
          final potWidth = (sceneWidth * 0.54).clamp(158.0, 284.0).toDouble();
          final headlineSize = (contentWidth * (compactHeight ? 0.17 : 0.19))
              .clamp(compactHeight ? 38.0 : 44.0, shortScreen ? 62.0 : 82.0)
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
                          vertical: compactHeight
                              ? 10
                              : (shortScreen ? 24 : (phoneWidth ? 24 : 50)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const _BrandPill()
                                .animate()
                                .fadeIn(
                                  delay: _brandStart,
                                  duration: _brandDuration,
                                  curve: Curves.easeOutCubic,
                                )
                                .slideY(
                                  begin: -0.8,
                                  end: 0,
                                  delay: _brandStart,
                                  duration: _brandDuration,
                                  curve: Curves.easeOutBack,
                                ),
                            SizedBox(
                              height: compactHeight
                                  ? 12
                                  : (shortScreen ? 18 : 30),
                            ),
                            _GradientHeadline(fontSize: headlineSize)
                                .animate()
                                .fadeIn(
                                  delay: _headlineStart,
                                  duration: _headlineDuration,
                                  curve: Curves.easeOutCubic,
                                )
                                .slideY(
                                  begin: 0.58,
                                  end: 0,
                                  delay: _headlineStart,
                                  duration: _headlineDuration,
                                  curve: Curves.easeOutBack,
                                ),
                            SizedBox(
                              height: compactHeight
                                  ? 8
                                  : (shortScreen ? 12 : 20),
                            ),
                            ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 500,
                                  ),
                                  child: _SplashSubtitle(
                                    fontSize: compactHeight || width < 390
                                        ? 13
                                        : 16,
                                  ),
                                )
                                .animate()
                                .fadeIn(
                                  delay: _subtitleStart,
                                  duration: _subtitleDuration,
                                  curve: Curves.easeOutCubic,
                                )
                                .slideX(
                                  begin: 0.42,
                                  end: 0,
                                  delay: _subtitleStart,
                                  duration: _subtitleDuration,
                                  curve: Curves.easeOutCubic,
                                ),
                            SizedBox(height: compactHeight ? 8 : 10),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _CookingScene(
                                        sceneWidth: sceneWidth,
                                        sceneHeight: sceneHeight,
                                        fireSize: fireSize,
                                        potWidth: potWidth,
                                      ),
                                      VerticalGap(
                                        compactHeight
                                            ? 4
                                            : (shortScreen ? 10 : 20),
                                      ),
                                      const SplashLoadingText()
                                          .animate()
                                          .fadeIn(
                                            delay: _loadingStart,
                                            duration: _loadingDuration,
                                            curve: Curves.easeOutCubic,
                                          )
                                          .slideY(
                                            begin: 0.32,
                                            end: 0,
                                            delay: _loadingStart,
                                            duration: _loadingDuration,
                                            curve: Curves.easeOutCubic,
                                          ),
                                      VerticalGap(
                                        compactHeight
                                            ? 4
                                            : (shortScreen ? 14 : 40),
                                      ),
                                    ],
                                  ),
                                ),
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
      fontWeight: FontWeight.w900,
      height: 0.92,
    );

    return Semantics(
      label: AppConstants.splashHeadline,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Cooking the ', style: baseStyle),
                    TextSpan(
                      text: 'next hot',
                      style: baseStyle.copyWith(
                        color: AppColors.splashTextYellow,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.splashTextYellow,
                      AppColors.splashTextOrange,
                      AppColors.splashTextRed,
                    ],
                    stops: [0.0, 0.54, 1.0],
                  ).createShader(bounds);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    'batch',
                    textAlign: TextAlign.center,
                    style: baseStyle.copyWith(
                      color: AppColors.splashTextYellow,
                      fontSize: fontSize * 0.98,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
            text: 'Fresh Karachi style biryani, fired up for ',
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
          Positioned.fill(
            child: const SplashSparksAnimation().animate().fadeIn(
              delay: _fireStart,
              duration: _fireDuration,
              curve: Curves.easeOutCubic,
            ),
          ),
          Positioned(
            bottom: sceneHeight * 0.00,
            child: SplashFirewoodAnimation(size: fireSize)
                .animate()
                .fadeIn(
                  delay: _fireStart,
                  duration: _fireDuration,
                  curve: Curves.easeOutCubic,
                )
                .slideX(
                  begin: -0.72,
                  end: 0,
                  delay: _fireStart,
                  duration: _fireDuration,
                  curve: Curves.easeOutBack,
                ),
          ),
          Positioned(
            top: sceneHeight * 0.06,
            child:
                SplashSmokeAnimation(
                  width: potWidth * 0.92,
                  height: sceneHeight * 0.46,
                ).animate().fadeIn(
                  delay: _potStart,
                  duration: _potDuration,
                  curve: Curves.easeOutCubic,
                ),
          ),
          Positioned(
            bottom: sceneHeight * 0.15,
            child: SplashCookingPot(width: potWidth)
                .animate()
                .fadeIn(
                  delay: _potStart,
                  duration: _potDuration,
                  curve: Curves.easeOutCubic,
                )
                .slideX(
                  begin: 0.72,
                  end: 0,
                  delay: _potStart,
                  duration: _potDuration,
                  curve: Curves.easeOutBack,
                ),
          ),
        ],
      ),
    );
  }
}
