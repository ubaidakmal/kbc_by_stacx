import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_spacing.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    required this.dishTargetKey,
    required this.revealProgress,
    required this.exitProgress,
    super.key,
  });

  final GlobalKey dishTargetKey;
  final double revealProgress;
  final double exitProgress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        final progress = Curves.easeOutCubic.transform(
          revealProgress.clamp(0, 1),
        );
        final exit = Curves.easeInCubic.transform(exitProgress.clamp(0, 1));

        return Transform.translate(
          offset: Offset(0, ((1 - progress) * 42) - (exit * 96)),
          child: Opacity(
            opacity: (progress.clamp(0.08, 1) * (1 - exit)).clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: compact ? 64 : 96,
                horizontal: compact ? 0 : 8,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.055),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackOverlay.withValues(alpha: 0.22),
                      blurRadius: 48,
                      offset: const Offset(0, 28),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(compact ? 22 : 40),
                  child: compact
                      ? Column(
                          children: [
                            _AboutDishAnchor(targetKey: dishTargetKey),
                            const VerticalGap(26),
                            const _AboutCopy(centered: true),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: _AboutDishAnchor(targetKey: dishTargetKey),
                            ),
                            const HorizontalGap(42),
                            const Expanded(
                              flex: 10,
                              child: _AboutCopy(centered: false),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AboutDishAnchor extends StatelessWidget {
  const _AboutDishAnchor({required this.targetKey});

  final GlobalKey targetKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 360.0);

        return Center(
          child: Container(
            key: targetKey,
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.splashDeepRed.withValues(alpha: 0.42),
              border: Border.all(
                color: AppColors.splashTextYellow.withValues(alpha: 0.18),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.splashWarmOrangeGlow.withValues(alpha: 0.22),
                  blurRadius: 70,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AboutCopy extends StatelessWidget {
  const _AboutCopy({required this.centered});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppImages.logo,
            width: centered ? 72 : 100,
            height: centered ? 72 : 100,
            fit: BoxFit.contain,
          ),
        ),
        const VerticalGap(16),
        Text(
          AppConstants.aboutHeadline,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.splashTextPrimary,
            fontSize: centered ? 34 : 48,
            fontWeight: FontWeight.w900,
            height: 1.02,
          ),
        ),
        const VerticalGap(18),
        Container(
          width: 86,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [
                AppColors.splashTextYellow,
                AppColors.splashTextOrange,
                AppColors.splashTextRed,
              ],
            ),
          ),
        ),
        const VerticalGap(22),
        Text(
          AppConstants.aboutDescription,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: AppTextStyles.body.copyWith(
            color: AppColors.splashTextMuted,
            fontSize: centered ? 15 : 17,
            height: 1.62,
          ),
        ),
      ],
    );
  }
}
