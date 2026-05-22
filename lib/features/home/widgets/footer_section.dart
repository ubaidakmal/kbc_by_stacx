import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_spacing.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;

        return Padding(
          padding: EdgeInsets.fromLTRB(8, compact ? 24 : 34, 8, 28),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.045),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.splashTextPrimary.withValues(alpha: 0.1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 20 : 30,
                    vertical: compact ? 22 : 24,
                  ),
                  child: compact
                      ? const Column(
                          children: [
                            _FooterBrand(centered: true),
                            VerticalGap(18),
                            _FooterCopyright(centered: true),
                          ],
                        )
                      : const Row(
                          children: [
                            Expanded(child: _FooterBrand(centered: false)),
                            HorizontalGap(28),
                            Expanded(child: _FooterCopyright(centered: false)),
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

class _FooterBrand extends StatelessWidget {
  const _FooterBrand({required this.centered});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: centered
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      mainAxisSize: centered ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Image.asset(AppImages.logo, width: 46, height: 46, fit: BoxFit.contain),
        const HorizontalGap(12),
        Flexible(
          child: Column(
            crossAxisAlignment: centered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.heroBrandName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.splashTextPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const VerticalGap(4),
              Text(
                AppConstants.footerTagline,
                textAlign: centered ? TextAlign.center : TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.splashTextMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterCopyright extends StatelessWidget {
  const _FooterCopyright({required this.centered});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.end,
      children: [
        Text(
          AppConstants.visitAddress,
          textAlign: centered ? TextAlign.center : TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.splashTextSoft,
            fontSize: 12,
          ),
        ),
        const VerticalGap(8),
        Text(
          AppConstants.footerCopyright,
          textAlign: centered ? TextAlign.center : TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.copyWith(
            color: AppColors.splashTextMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
